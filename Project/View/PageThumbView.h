//
//  PageThumbView.h
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Page;
@class PageThumbView;

@protocol PageThumbViewDelegate <NSObject>
- (void) clickedOnPageThumbView: (PageThumbView*) thumbView;
- (void) removePageThumbView: (PageThumbView*) thumbView;
@end

@interface PageThumbView : UIView
{
    IBOutlet UIImageView*       imageView;
    IBOutlet UIButton*          btnClose;
}

@property (nonatomic, strong) Page* currentPage;
@property (nonatomic, strong) id<PageThumbViewDelegate> delegate;

+ (PageThumbView*) viewWithPage: (Page*) page;
+ (PageThumbView*) viewWithPage: (Page*) page withDelegate: (id<PageThumbViewDelegate>) delegate;
- (void) resetWithPage: (Page*) page;
- (void) startEdition;
- (BOOL) endEdition;
@end
