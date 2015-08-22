//
//  CreateProjectViewController.h
//  Project
//
//  Created by Admin on 3/6/15.
//  Copyright (c) 2015 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateProjectDelegate <NSObject>

@optional
- (void) didGetProjectName:(NSString *) projectName;

@end

@interface CreateProjectViewController : UIViewController

@property (nonatomic, retain) id<CreateProjectDelegate> delegate;

@end
