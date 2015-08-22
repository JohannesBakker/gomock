//
//  VoicesViewController.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectManager.h"
#import "VoiceRecordViewController.h"

@interface VoicesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, VoiceRecordDelegate, AVAudioPlayerDelegate>
{
    IBOutlet    UITableView*            tblrecordVoices;
    IBOutlet    UILabel*                lblTitle;
}

@property (nonatomic,strong)  AVAudioPlayer* audioPlayer;

@property (nonatomic, strong) NSMutableArray*   recordVoices;
@property (nonatomic, strong) Project*  currentProject;

- (id) initWithProject: (Project*) project;
@end
