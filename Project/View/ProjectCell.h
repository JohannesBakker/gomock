//
//  ProjectCell.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROJECTCELL_HEIGHT      50

@class Project;
@interface ProjectCell : UITableViewCell
{
    IBOutlet UILabel*           lblTitle;
    IBOutlet UIImageView*       imgBack;
}
@property (nonatomic, strong) Project* currentProject;

- (void) resetWithProject: (Project*) project;
@end
