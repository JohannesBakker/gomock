//
//  ProjectPreviewViewController.h
//  Project
//
//  Created by Mountain on 6/18/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageActionView.h"

@class Project;
@class Page;

@interface ProjectPreviewViewController : UIViewController <PageActionViewDelegate>
@property (nonatomic, strong) PageActionView* activeActionView;
@property (nonatomic, strong) PageActionView* candidateActionView;

@property (nonatomic, strong) Page* currentPage;
@property (nonatomic, strong) Project* currentProject;

- (id) initWithPage: (Page*) page;
@end
