//
//  ProjectCell.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECORDCELL_HEIGHT      50

@class Voice;
@interface RecordCell : UITableViewCell
{
    IBOutlet UILabel*           lblTitle;
    IBOutlet UIImageView*       imgBack;
}
@property (nonatomic, strong) Voice* currentVoice;

- (void) resetWithVoice: (Voice*) voice;
@end
