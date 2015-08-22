//
//  IntroPage.h
//  Project
//
//  Created by Mountain on 7/1/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroPageDelegate <NSObject>
- (void) pageButtonClicked: (id) introPage;
@end

@interface IntroPage : UIView
{
    IBOutlet UIImageView*   imgBack;
    IBOutlet UIButton*      btnGetStarted;    
}
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) id<IntroPageDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton*      btnGetStarted;

- (void) resetWithBackground: (UIImage*) image withButton: (BOOL) bWithButton;
@end
