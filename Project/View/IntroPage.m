//
//  IntroPage.m
//  Project
//
//  Created by Mountain on 7/1/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "IntroPage.h"

@implementation IntroPage
@synthesize index;
@synthesize delegate;
@synthesize btnGetStarted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) resetWithBackground: (UIImage*) image withButton: (BOOL) bWithButton
{
    imgBack.image = image;
    if (bWithButton) {
        btnGetStarted.hidden = NO;
    }
    else
    {
        btnGetStarted.hidden = YES;
    }    
}

- (IBAction) onGetStarted: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(pageButtonClicked:)]) {
        [self.delegate pageButtonClicked: self];
    }
}

@end
