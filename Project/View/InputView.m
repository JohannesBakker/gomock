//
//  AlertView.m
//  GPSGLOSEF
//
//  Created by Mountain on 5/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "InputView.h"

@implementation InputView
static InputView*   sharedView = nil;

@synthesize alertDelegate;
@synthesize inputedData;

+ (InputView*) showInputWithDelegate: (id<InputViewDelegate>) delegate
{
    if (sharedView == nil) {
        sharedView = (id)[[[NSBundle mainBundle] loadNibNamed: @"InputView" owner:nil options: nil] objectAtIndex: 0];
        [[UIApplication sharedApplication].keyWindow addSubview: sharedView];
    }
    else
    {
        [sharedView.superview bringSubviewToFront: sharedView];
    }
    
    sharedView.alertDelegate = delegate;
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    sharedView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    sharedView.alpha = 0.0f;

    [UIView animateWithDuration: 0.3f animations:^{
        sharedView.alpha = 1.0f;
    }];
    
    return sharedView;
}

- (IBAction) onOk:(id)sender
{
    self.inputedData = txtInput.text;
    if (self.alertDelegate && [self.alertDelegate respondsToSelector: @selector(alertView:clickedButtonAtIndex:)]) {
        [self.alertDelegate alertView: self clickedButtonAtIndex: 0];
    }
    self.alpha = 0.0f;
}

- (IBAction) onCancel:(id)sender
{
    if (self.alertDelegate && [self.alertDelegate respondsToSelector: @selector(alertView:clickedButtonAtIndex:)]) {
        [self.alertDelegate alertView: self clickedButtonAtIndex: 1];
    }
    self.alpha = 0.0f;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
