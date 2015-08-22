//
//  VoiceRecordViewController.h
//  Project
//
//  Created by Admin on 3/6/15.
//  Copyright (c) 2015 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol VoiceRecordDelegate <NSObject>

@optional
- (void) didGetVoiceName:(NSString *) szFileName path:(NSString *) szPath;

@end

@interface VoiceRecordViewController : UIViewController<AVAudioRecorderDelegate>

@property (nonatomic,strong) AVAudioRecorder* audioRecorder;

@property (nonatomic, retain) id<VoiceRecordDelegate> delegate;

@end
