//
//  AlertView.h
//  GPSGLOSEF
//
//  Created by Mountain on 5/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputView;

@protocol InputViewDelegate <NSObject>
- (void) alertView: (InputView*) alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface InputView : UIView
{
    IBOutlet UITextField*           txtInput;
}
@property (nonatomic, strong) NSString*                 inputedData;
@property (nonatomic, strong) id<InputViewDelegate>     alertDelegate;

+ (InputView*) showInputWithDelegate: (id<InputViewDelegate>) delegate;
@end
