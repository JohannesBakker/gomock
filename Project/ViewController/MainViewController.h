//
//  MainViewController.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "CreateProjectViewController.h"

@interface MainViewController : UIViewController <CreateProjectDelegate>
{
    IBOutlet    UITableView*            tblProjects;
    IBOutlet    UILabel*                lblTitle;
}

@property (nonatomic, strong) NSMutableArray*   projects;
@end
