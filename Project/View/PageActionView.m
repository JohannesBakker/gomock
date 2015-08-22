//
//  PageActionView.m
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "PageActionView.h"
#import <QuartzCore/QuartzCore.h>
#import "Page.h"
#import "Link.h"
#import "CropViewLayer.h"

@implementation PageActionView
@synthesize delegate;
@synthesize currentPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (PageActionView*) viewWithPage: (Page*) page
{
    PageActionView* actionView = [[[NSBundle mainBundle] loadNibNamed: @"PageActionView" owner: nil options: nil] objectAtIndex: 0];
    actionView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [actionView resetWithPage: page];
    return actionView;
}

- (void) resetWithPage: (Page*) page
{
    if (cropLayers == nil) {
        cropLayers = [NSMutableArray array];
    }
    else
    {
        for (CropViewLayer* layer in cropLayers) {
            [layer removeFromSuperview];
        }
        [cropLayers removeAllObjects];
    }
    
    self.currentPage = page;
    imageView.image = page.image;
    
    [self initCropLayers];
}

- (void) initCropLayers
{
    CGRect rtBounds = [[UIScreen mainScreen] applicationFrame];
    float height = rtBounds.size.height - 44 - 55;
    float rate = 450 / height;

    for (Link* link in self.currentPage.links) {
        CropViewLayer* cropLayer = [[CropViewLayer alloc] initWithFrame:
                                    CGRectMake( link.rectInPage.origin.x * rate, link.rectInPage.origin.y * rate,
                                               link.rectInPage.size.width * rate, link.rectInPage.size.height * rate)];
        cropLayer.alpha = 0.05f;
        cropLayer.link = link;
        if (link.linkedPage != 0) {
            cropLayer.cropLayerType = WITH_LINK;
        }
        else
        {
            cropLayer.cropLayerType = WITHOUT_LINK;
        }
        [imageView addSubview: cropLayer];
        [cropLayers addObject: cropLayer];
    }
}

- (Link*) checkPointInCropView: (CropViewLayer*) cropView point: (CGPoint) point
{
    if(point.x < 0 || point.y < 0 || point.x > imageView.bounds.size.width || point.y > imageView.bounds.size.height)
    {
        return nil;
    }
    
    CGRect rtCropView = cropView.frame;
    if ((point.x > rtCropView.origin.x) && (point.x < (rtCropView.origin.x + rtCropView.size.width)) &&
             (point.y > rtCropView.origin.y) && (point.y < (rtCropView.origin.y + rtCropView.size.height)))
    {
        return cropView.link;
    }
    else
        return nil;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint locationPoint = [[touches anyObject] locationInView: imageView];

    BOOL linkTouched = NO;
    for (CropViewLayer* cropLayer in cropLayers) {
        Link* link = [self checkPointInCropView: cropLayer point: locationPoint];
        if (link != nil) {
            if (self.delegate && [self.delegate respondsToSelector: @selector(linkClicked:)]) {
                [self.delegate linkClicked: link];
            }
            linkTouched = YES;
            break;
        }
    }
    
    if (!linkTouched) {
        [self highlightLinks: YES];
    }
}

- (void) highlightLinks: (BOOL) bHighlight
{
    [UIView animateWithDuration: 0.4f animations:^{
        for (CropViewLayer* cropLayer in cropLayers) {
            if (bHighlight) {
                cropLayer.alpha = 1.0f;
            }
            else
            {
                cropLayer.alpha = 0.05f;
            }
        }
    } completion:^(BOOL finished) {
        if (bHighlight) {
            [self highlightLinks: NO];
        }
    }];
}

@end
