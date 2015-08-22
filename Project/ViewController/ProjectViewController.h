//
//  ProjectViewController.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTakeViewController.h"
#import "PageThumbView.h"

@class Project;

@interface ProjectViewController : UIViewController <UIImagePickerControllerDelegate, PhotoTakeViewControllerDelegate, PageThumbViewDelegate>
{
    IBOutlet    UILabel*        lblTitle;
    IBOutlet    UIScrollView*   scrollPages;
    NSMutableArray*             pageViews;
}

@property (nonatomic, strong) Project*  currentProject;

- (id) initWithProject: (Project*) project;
@end
