//
//  PageViewController.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageListViewController.h"

typedef enum {
    LeftTop = 0,
    RightTop= 1,
    LeftBottom = 2,
    RightBottom = 3,
    MoveCenter = 4,
    NoPoint = -1
} eRectPoint;

@class Page;
@class CropViewLayer;
@interface PageEditViewController : UIViewController <PageListViewControllerDelegate>
{
    IBOutlet    UIImageView*    imageView;
    NSMutableArray*             cropLayers;
    
    eRectPoint                  _movePoint;
    CropViewLayer*              _selectedCropView;
    CGPoint                     _lastMovePoint;
    
    UIMenuController*           menuController;
}

@property (nonatomic, strong) Page* currentPage;

- (id) initWithPage: (Page*) page;
@end
