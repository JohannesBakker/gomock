//
//  ShareManager.m
//  Project
//
//  Created by Mountain on 6/24/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "ShareManager.h"
#import "Page.h"
#import "Link.h"
#import "Project.h"
#import "Voice.h"
#import "ZipArchive.h"
#import "AppDelegate.h"

@implementation ShareManager
static ShareManager* sharedShareManager = nil;

@synthesize currentProject;
@synthesize currentArchive;

+ (ShareManager*) manager
{
    if (sharedShareManager == nil) {
        sharedShareManager = [ShareManager new];
    }
    return sharedShareManager;
}

+ (void) shareProject: (Project*) project
{
    ShareManager* manager = [ShareManager manager];
    
    NSString* dPath = NSTemporaryDirectory();
    NSString* zipfile = [dPath stringByAppendingPathComponent:@"project.zip"];
    ZipArchive* zip = [[ZipArchive alloc] init];
    BOOL ret = [zip CreateZipFile2:zipfile];
    if (ret) {
        manager.currentArchive = zip;
        manager.currentProject = project;
        [manager appendPagesToZip];
        [manager shareViaEmail];
    }
}

- (void) appendPagesToZip
{
    NSString* pageFileName = nil;
    NSString* imageFileName = nil;
    
    for (Page* page in self.currentProject.pages) {
        NSData* data = [self htmlDataFromPage: page];
        
        pageFileName = [NSString stringWithFormat: @"Page%d.html", page.index];
        imageFileName = [NSString stringWithFormat: @"Page%d.png", page.index];
        [self writeDataToFile: data file: pageFileName];
        [self writeDataToFile: UIImagePNGRepresentation(page.image) file: imageFileName];
        [self addFileToZip: pageFileName];
        [self addFileToZip: imageFileName];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : @"";
    for (Voice* voice in self.currentProject.voices) {
        NSString *voicePath = [basePath stringByAppendingPathComponent: voice.title];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:voicePath])
        {
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:voicePath];
            NSString* szVoiceName = [NSString stringWithFormat: @"voice%d.caf", voice.index];
            [self writeDataToFile: data file: szVoiceName];
            [self addFileToZip: szVoiceName];
        }
        else {
            NSLog(@"File not exists");
        }
    }
    
    [self.currentArchive CloseZipFile2];
}

- (void) addFileToZip: (NSString*) filename
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent: filename];    
    [self.currentArchive addFileToZip: filePath newname: filename];
}

- (void) writeDataToFile: (NSData*) data file: (NSString*) filename
{
    NSURL *fURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: filename]];
    [data writeToURL: fURL atomically: YES];
}

- (NSData*) htmlDataFromPage: (Page*) page
{
//Sort Page Links By Position
    NSArray* sortedArray = [page.links sortedArrayUsingComparator: ^NSComparisonResult(id a, id b) {
        Link* first = (Link*)a;
        Link* second = (Link*)b;
        return [first compare:second];
    }];

    CGRect rtBounds = [[UIScreen mainScreen] applicationFrame];
    int height = rtBounds.size.height - 44 - 55;
    int width = height / 1.5f;

    NSString* header = [NSString stringWithFormat: @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">"
    @"<HTML>"
    @"<HEAD>"
    @"<TITLE> New Document </TITLE>"
    @"<META NAME=\"Generator\" CONTENT=\"EditPlus\">"
    @"<META NAME=\"Author\" CONTENT=\"\">"
    @"<META NAME=\"Keywords\" CONTENT=\"\">"
    @"<META NAME=\"Description\" CONTENT=\"\">"
    @""
    @"<style>"
    @"#wraper {"
    @"width: %dpx;"
    @"height: %dpx;"
    @"background: url('Page%d.png');"
    @"background-size: cover;"
    @"}"
    @"</style>"
    @"</HEAD>"
    @""
    @"<BODY>"
    @"<div id=\"wraper\">", width, height, page.index];
    
    NSString* ender = @"</div>"
    @"</BODY>"
    @"</HTML>";
    
    NSMutableString* content = [NSMutableString string];
    int count = [sortedArray count];
    for (int i=0; i<count; i++) {
        Link* link = [sortedArray objectAtIndex: i];
        NSString* linkStr = @"";
        if (i == 0) {
            linkStr = [self stringFromLink: link prevLink: nil];
        }
        else
        {
            linkStr = [self stringFromLink: link prevLink: [sortedArray objectAtIndex: i-1]];
        }
        [content appendString: linkStr];
    }
    
    NSString* pageStr = [NSString stringWithFormat: @"%@%@%@", header, content, ender];
    return [pageStr dataUsingEncoding: NSUTF8StringEncoding];
}

- (NSString*) stringFromLink: (Link*) link prevLink: (Link*) prevLink
{
    NSString* linkedPageString = [NSString stringWithFormat: @"Page%d.html", link.linkedPage];
    if (link.linkedPage == 0) {
        return @"";
    }
    else
    {
        int marginTop, marginLeft, width, height;
        if (prevLink == 0) {
            marginTop = link.rectInPage.origin.y;
            marginLeft = link.rectInPage.origin.x;
        }
        else
        {
            marginTop = link.rectInPage.origin.y - prevLink.rectInPage.origin.y - prevLink.rectInPage.size.height;
            marginLeft = link.rectInPage.origin.x - prevLink.rectInPage.origin.x;
        }
        width = link.rectInPage.size.width;
        height = link.rectInPage.size.height;
        
        NSMutableString* content = [NSMutableString string];
        [content appendFormat: @"<a href=\"%@\">", linkedPageString];
        [content appendFormat: @"<img src=\"\" style=\"margin-left: %dpx; margin-top: %dpx;\" border=\"1\" height=\"%d\" width=\"%d\" align=\"left\" color=#ff0000/>", marginLeft, marginTop, height, width];
        [content appendFormat: @"</a>"];
        return content;
    }
}

- (void) shareViaEmail
{
    UIViewController* rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.navigationBar.tintColor = [UIColor darkGrayColor];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject: [NSString stringWithFormat: @"Project Flow - %@", self.currentProject.title]];

    NSURL *zipfile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: @"project.zip"]];
    NSData* data = [NSData dataWithContentsOfURL: zipfile];
    [mailViewController addAttachmentData: data mimeType:@"application/zip" fileName: @"Project.zip"];
    
    [rootViewController presentViewController: mailViewController animated: YES completion: nil];
}


#pragma mark MailComposeViewController Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Cancelled sending");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Message Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Message Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Sending Failed");
            break;
        default:
            NSLog(@"Message not sent");
            break;
    }
    UIViewController* rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController dismissViewControllerAnimated: YES completion: nil];
}

@end
