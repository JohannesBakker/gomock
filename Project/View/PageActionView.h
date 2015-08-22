//
//  PageActionView.h
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Page;
@class Link;

@protocol PageActionViewDelegate <NSObject>
- (void) linkClicked: (Link*) link;
@end

@interface PageActionView : UIView
{
    IBOutlet UIImageView*        imageView;
    NSMutableArray*     cropLayers;
}

@property (nonatomic, strong) Page* currentPage;
@property (nonatomic, strong) id<PageActionViewDelegate> delegate;

+ (PageActionView*) viewWithPage: (Page*) page;
- (void) resetWithPage: (Page*) page;
@end
