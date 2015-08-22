//
//  ProjectCell.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "RecordCell.h"
#import "Voice.h"

@implementation RecordCell
@synthesize currentVoice;

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

- (void) resetWithVoice: (Voice*) voice
{
    self.currentVoice = voice;
    lblTitle.text = voice.title;
//    lblTitle.font = [UIFont fontWithName: @"BALLPARK" size: 20];
}

@end
