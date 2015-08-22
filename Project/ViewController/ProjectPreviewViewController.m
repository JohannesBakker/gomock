//
//  ProjectPreviewViewController.m
//  Project
//
//  Created by Mountain on 6/18/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "ProjectPreviewViewController.h"
#import "Page.h"
#import "Project.h"
#import "Link.h"

@interface ProjectPreviewViewController ()

@end

@implementation ProjectPreviewViewController
@synthesize activeActionView;
@synthesize candidateActionView;
@synthesize currentPage;
@synthesize currentProject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithPage: (Page*) page
{
    self = [super initWithNibName: @"ProjectPreviewViewController" bundle: nil];
    if (self) {
        self.currentPage = page;
        self.currentProject = page.project;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.activeActionView = [PageActionView viewWithPage: self.currentPage];
    self.candidateActionView = [PageActionView viewWithPage: self.currentPage];
    self.activeActionView.delegate = self;
    self.candidateActionView.delegate = self;
    CGRect rt = [[UIScreen mainScreen] applicationFrame];
    self.activeActionView.center = CGPointMake(rt.size.width/2, rt.size.height / 2);
    self.candidateActionView.center = CGPointMake(rt.size.width/2, rt.size.height / 2);
    
    [self.view addSubview: self.candidateActionView];
    [self.view addSubview: self.activeActionView];
    
    UIPinchGestureRecognizer* recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector( onPinch: )];
    [self.view addGestureRecognizer: recognizer];
}

- (void) onPinch: (id) sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark PageActionViewDelegate

- (void) linkClicked:(Link *)link
{
    if (link.linkedPage == 0) {
        return;
    }
    
    Page* linkedPage = (id)[self.currentProject.pages objectAtIndex: link.linkedPage - 1];
    [self.candidateActionView resetWithPage: linkedPage];

    CGRect rt = self.candidateActionView.frame;
    rt.origin.x = 320;
    self.candidateActionView.frame = rt;

    [UIView animateWithDuration: 0.5f animations:^{
        CGRect rt = self.candidateActionView.frame;
        rt.origin.x = 0;
        self.candidateActionView.frame = rt;

        rt = self.activeActionView.frame;
        rt.origin.x = -320;
        self.activeActionView.frame = rt;
    } completion:^(BOOL finished) {
        PageActionView* tempActionView = self.activeActionView;
        self.activeActionView = self.candidateActionView;
        self.candidateActionView = tempActionView;
    }];
}
@end
