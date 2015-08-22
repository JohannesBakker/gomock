//
//  ProjectViewController.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "ProjectViewController.h"
#import "Project.h"
#import "Page.h"
#import "ProjectManager.h"
#import "ShareManager.h"
#import "ProjectPreviewViewController.h"
#import "PageEditViewController.h"
#import "VoicesViewController.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController
@synthesize currentProject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithProject: (Project*) project
{
    self = [super initWithNibName: @"ProjectViewController" bundle: nil];
    if (self) {
        self.currentProject = project;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text = self.currentProject.title;
    pageViews = [NSMutableArray array];
//    lblTitle.font = [UIFont fontWithName: @"BALLPARK" size: 24];
    [self resetPages];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void) resetPages
{
    for (UIView* subview in pageViews) {
        [subview removeFromSuperview];
    }
    
    NSMutableArray* pages = self.currentProject.pages;
    int count = [pages count];
    
    int x, y;
    int gap = 10;
    CGFloat width = (self.view.bounds.size.width - gap*4) / 3.0f;
    CGFloat height = width * 1.5f;
    for (int i=0; i<count; i++) {
        Page* page = [pages objectAtIndex: i];
        x = gap + (i%3) * (width + gap);
        y = gap + (i/3) * (height + gap);
        PageThumbView* thumbView = [PageThumbView viewWithPage: page withDelegate: self];
        thumbView.frame = CGRectMake(x, y, width, height);
        [scrollPages addSubview: thumbView];
        [pageViews addObject: thumbView];
    }
    
    [scrollPages setContentSize: CGSizeMake(self.view.bounds.size.width, ((count+2)/3) * (height + gap) + 20)];
}

- (void) layoutPageViews
{
    [UIView animateWithDuration: 0.3f animations:^{
        int count = [self.currentProject.pages count];
        
        int x, y;
        int gap = 10;
        CGFloat width = (self.view.bounds.size.width - gap*4) / 3.0f;
        CGFloat height = width * 1.5f;
        
        for (int i=0; i<count; i++) {
            x = gap + (i%3) * (width + gap);
            y = gap + (i/3) * (height + gap);
            
            PageThumbView* thumbView = [pageViews objectAtIndex: i];
            thumbView.frame = CGRectMake(x, y, width, height);
        }
        
        [scrollPages setContentSize: CGSizeMake(self.view.bounds.size.width, ((count+2)/3) * (height + gap) + 20)];
    }];
}

- (void) addPageWithImage: (UIImage*) image
{
    Page* page = [Page new];
    page.image = image;
    page.project = self.currentProject;
    page.index = [self.currentProject.pages count] + 1;
    [self.currentProject.pages addObject: page];

    PageThumbView* thumbView = [PageThumbView viewWithPage: page withDelegate: self];
    [scrollPages addSubview: thumbView];
    [pageViews addObject: thumbView];
    
    [self layoutPageViews];
}

- (IBAction) onCamera:(id)sender
{
    PhotoTakeViewController* pController = [PhotoTakeViewController new];
    pController.delegate = self;
    [self.navigationController pushViewController: pController animated: YES];
}

- (IBAction) onPlay:(id)sender
{
    if ([self.currentProject.pages count] == 0) {
        return;
    }
    
    ProjectPreviewViewController* pController = [[ProjectPreviewViewController alloc] initWithPage: [self.currentProject.pages objectAtIndex: 0]];
    [self presentViewController: pController animated: YES completion: nil];
}

- (IBAction) onRecord:(id) sender {
    VoicesViewController* pController = [[VoicesViewController alloc] init];
    pController.currentProject = self.currentProject;
    [self.navigationController pushViewController:pController animated:YES];
}

- (IBAction) onShare:(id)sender
{
    [ShareManager shareProject: self.currentProject];    
}

- (IBAction) onBack:(id)sender
{
    [[ProjectManager manager] saveToDefaults];
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onEdit:(id)sender
{
    for (PageThumbView* thumbView in pageViews) {
        [thumbView startEdition];
    }
}

#pragma mark PageThumbViewDelegate
- (void) clickedOnPageThumbView:(PageThumbView *)thumbView
{
    BOOL bWasAnimating = NO;
    for (PageThumbView* thumbView in pageViews) {
        if ([thumbView endEdition] == YES) { //There were at least 1 animated view
            bWasAnimating = YES;
        }
    }
    
    if (bWasAnimating) {
        return;
    }
    
    PageEditViewController* pController = [[PageEditViewController alloc] initWithPage: thumbView.currentPage];
    [self.navigationController pushViewController: pController animated: YES];
    NSLog(@"PageThumbView Selected");
}

- (void) removePageThumbView:(PageThumbView *)thumbView
{
    NSInteger index = thumbView.currentPage.index;
    NSInteger count = [self.currentProject.pages count];
    
    for (int i=index; i < count; i++) {
        Page* page = [self.currentProject.pages objectAtIndex: i];
        page.index = i;
    }
    
    for (Page* page in self.currentProject.pages) {
        [page removeLinkWithIndex: index];
    }
    
    [self.currentProject.pages removeObject: thumbView.currentPage];
    [pageViews removeObject: thumbView];
    [thumbView removeFromSuperview];
    
    [self layoutPageViews];
}

#pragma mark PhotoTakenViewController Delegate
- (void) photoTaken:(UIImage *)image
{
    [self addPageWithImage: image];
}

@end
