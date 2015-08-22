//
//  ProjectCell.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "ProjectCell.h"
#import "Project.h"

@implementation ProjectCell
@synthesize currentProject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        imgBack.image = [UIImage imageNamed: @"bg_tbl_selected_witharrow.png"];
    }
    else
    {
        imgBack.image = [UIImage imageNamed: @"bg_tbl_witharrow.png"];
    }
}

- (void) resetWithProject: (Project*) project
{
    self.currentProject = project;
    lblTitle.text = project.title;
//    lblTitle.font = [UIFont fontWithName: @"BALLPARK" size: 20];
}

@end
