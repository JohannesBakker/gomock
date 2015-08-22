//
//  PageListViewController.m
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "PageListViewController.h"
#import "Project.h"
#import "Page.h"
#import "Link.h"
#import "ShareManager.h"

@interface PageListViewController ()

@end

#define THUMB_TAG_BASE      100

@implementation PageListViewController
@synthesize currentLink;
@synthesize currentProject;
@synthesize selectedPage;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithProject: (Project*) project link: (Link*) link
{
    self = [super initWithNibName: @"PageListViewController" bundle: nil];
    if (self) {
        self.currentProject = project;
        self.currentLink = link;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text = self.currentProject.title;
//    lblTitle.font = [UIFont fontWithName: @"BALLPARK" size: 24];
    [self initThumbnails];
}

- (void) initThumbnails
{
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
        
        UIButton*   thumbView = [[UIButton alloc] initWithFrame: CGRectMake(x, y, width, height)];
        [thumbView setBackgroundImage: page.image forState: UIControlStateNormal];
        thumbView.tag = THUMB_TAG_BASE + i;
        [thumbView addTarget: self action: @selector(thumbSelected:) forControlEvents: UIControlEventTouchDown];
        
        if (page == self.currentLink.currentPage) {
            thumbView.enabled = NO;
        }
        
        if (page.index == self.currentLink.linkedPage) {
            [self highlightPage: thumbView];
        }
        
        [scrollPages addSubview: thumbView];
    }
    [scrollPages setContentSize: CGSizeMake(self.view.bounds.size.width, ((count+2)/3) * (height + gap) + 20)];
}

- (void) highlightPage: (UIButton*) thumbView
{
    NSInteger index = thumbView.tag - THUMB_TAG_BASE;
    self.selectedPage = [self.currentProject.pages objectAtIndex: index];
    imgHighlight.hidden = NO;
    imgHighlight.frame = CGRectInset(thumbView.frame, -5, -5);
}

- (IBAction) onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onDone:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(pageSelected:)]) {
        if (self.selectedPage != nil) {
            [self.delegate pageSelected: self.selectedPage];
        }
    }
    [self.navigationController popViewControllerAnimated: YES];    
}

- (IBAction) onShare:(id)sender
{
    [ShareManager shareProject: self.currentProject];
}

- (void) thumbSelected:(UIButton*) thumbView
{
    [self highlightPage: thumbView];
    NSLog(@"PageThumbView Selected");
}
@end
