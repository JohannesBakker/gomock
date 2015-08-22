//
//  PageThumbView.m
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "PageThumbView.h"
#import "Page.h"
#import <QuartzCore/QuartzCore.h>

@implementation PageThumbView
@synthesize currentPage;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (PageThumbView*) viewWithPage: (Page*) page
{
    return [self viewWithPage: page withDelegate: nil];
}

+ (PageThumbView*) viewWithPage: (Page*) page withDelegate: (id<PageThumbViewDelegate>) delegate
{
    PageThumbView* thumbView = [[[NSBundle mainBundle] loadNibNamed: @"PageThumbView" owner: nil options: nil] objectAtIndex: 0];
    thumbView.layer.shadowColor = [UIColor grayColor].CGColor;
    thumbView.layer.shadowRadius = 2.0f;
    thumbView.layer.shadowOpacity = 0.8f;
    thumbView.layer.shadowOffset = CGSizeMake(1, 1);
    thumbView.delegate = delegate;
    [thumbView resetWithPage: page];
    return thumbView;
}

- (void) resetWithPage: (Page*) page
{
    self.currentPage = page;
    imageView.image = page.image;
    btnClose.hidden = YES;
    UILongPressGestureRecognizer* recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressed:)];
    [self addGestureRecognizer: recognizer];
}

- (IBAction) onRemove:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(removePageThumbView:)]) {
        [self.delegate removePageThumbView: self];
    }
}

- (IBAction) onSelected:(id)sender
{
    if (btnClose.hidden == NO) {
        [self endEdition];
    }
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(clickedOnPageThumbView:)]) {
        [self.delegate clickedOnPageThumbView: self];
    }
}

- (BOOL) endEdition
{
    [self.layer removeAllAnimations];    
    if (btnClose.hidden == NO) {
        btnClose.hidden = YES;
        return YES;
    }
    return NO;
}

- (void) startEdition
{
    btnClose.hidden = NO;
    [self shake];
}

- (void) longPressed: (id) sender
{
    [self startEdition];
}

- (void) shake
{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.07f];
    [animation setRepeatCount: 4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self center].x - 1.0f, [self center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self center].x + 1.0f, [self center].y)]];
    [[self layer] addAnimation:animation forKey:@"position"];
}
@end
