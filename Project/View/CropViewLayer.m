//
//  CropViewLayer.m
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "CropViewLayer.h"
#import <QuartzCore/QuartzCore.h>


@implementation CropViewLayer
@synthesize cropLayerType;
@synthesize isInEditing;
@synthesize link;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        backgroundView = [[UIView alloc] initWithFrame: self.bounds];
        backgroundView.layer.cornerRadius = 5.0f;
        backgroundView.layer.borderWidth = 2.0f;
        backgroundView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview: backgroundView];
        [self initCorners];

        self.isInEditing = NO;
        self.cropLayerType = WITHOUT_LINK;
    }
    return self;
}

- (void) initCorners
{
    leftTopCorner = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"corner_red.png"]];
    leftTopCorner.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    leftTopCorner.layer.shadowColor = [UIColor blackColor].CGColor;
    leftTopCorner.layer.shadowOffset = CGSizeMake(1, 1);
    leftTopCorner.layer.shadowOpacity = 0.6;
    leftTopCorner.layer.shadowRadius = 1.0;
    
    leftBottomCorner = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"corner_red.png"]];
    leftBottomCorner.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    leftBottomCorner.layer.shadowColor = [UIColor blackColor].CGColor;
    leftBottomCorner.layer.shadowOffset = CGSizeMake(1, 1);
    leftBottomCorner.layer.shadowOpacity = 0.6;
    leftBottomCorner.layer.shadowRadius = 1.0;
    
    rightTopCorner = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"corner_red.png"]];
    rightTopCorner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    rightTopCorner.layer.shadowColor = [UIColor blackColor].CGColor;
    rightTopCorner.layer.shadowOffset = CGSizeMake(1, 1);
    rightTopCorner.layer.shadowOpacity = 0.6;
    rightTopCorner.layer.shadowRadius = 1.0;
    
    rightBottomCorner = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"corner_red.png"]];
    rightBottomCorner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    rightBottomCorner.layer.shadowColor = [UIColor blackColor].CGColor;
    rightBottomCorner.layer.shadowOffset = CGSizeMake(1, 1);
    rightBottomCorner.layer.shadowOpacity = 0.6;
    rightBottomCorner.layer.shadowRadius = 1.0;
    
    leftTopCorner.center = self.bounds.origin;
    leftBottomCorner.center = CGPointMake(self.bounds.origin.x , self.bounds.origin.y + self.bounds.size.height);
    rightTopCorner.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width , self.bounds.origin.y);
    rightBottomCorner.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width , self.bounds.origin.y + self.bounds.size.height);
    
    [self addSubview:leftTopCorner];
    [self addSubview:leftBottomCorner];
    [self addSubview:rightTopCorner];
    [self addSubview:rightBottomCorner];
}

- (void) layoutSubviews
{
    backgroundView.frame = self.bounds;
}

- (void) setIsInEditing:(BOOL) bIsInEditing
{
    isInEditing = bIsInEditing;
    if (isInEditing) {
        leftTopCorner.hidden = NO;
        leftBottomCorner.hidden = NO;
        rightTopCorner.hidden = NO;
        rightBottomCorner.hidden = NO;
    }
    else
    {
        leftTopCorner.hidden = YES;
        leftBottomCorner.hidden = YES;
        rightTopCorner.hidden = YES;
        rightBottomCorner.hidden = YES;
    }
}

- (void) setCropLayerType:(NSInteger) eEditMode
{    
    cropLayerType = eEditMode;
    
    UIImage* image = nil;
    if (cropLayerType == WITHOUT_LINK) {
        image = [UIImage imageNamed: @"corner_red.png"];
        backgroundView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent: 0.8f].CGColor;
        backgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent: 0.3f];
    }
    else if (cropLayerType == WITH_LINK)
    {
        image = [UIImage imageNamed: @"corner_green.png"];
        backgroundView.layer.borderColor = [[UIColor greenColor] colorWithAlphaComponent: 0.8f].CGColor;
        backgroundView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent: 0.3f];        
    }
    
    leftTopCorner.image = image;
    leftBottomCorner.image = image;
    rightTopCorner.image = image;
    rightBottomCorner.image = image;
}

@end
