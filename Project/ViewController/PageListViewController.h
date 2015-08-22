//
//  PageListViewController.h
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;
@class Link;

@protocol PageListViewControllerDelegate <NSObject>
- (void) pageSelected: (id) selectedPage;
@end

@interface PageListViewController : UIViewController
{
    IBOutlet    UILabel*        lblTitle;
    IBOutlet    UIImageView*    imgHighlight;
    IBOutlet    UIScrollView*   scrollPages;
}

@property (nonatomic, strong) Project*  currentProject;
@property (nonatomic, strong) Link*     currentLink;
@property (nonatomic, strong) id        selectedPage;
@property (nonatomic, strong) id<PageListViewControllerDelegate>    delegate;

- (id) initWithProject: (Project*) project link: (Link*) link;

@end
