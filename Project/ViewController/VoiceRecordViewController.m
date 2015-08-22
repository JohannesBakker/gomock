//
//  VoiceRecordViewController.m
//  Project
//
//  Created by Admin on 3/6/15.
//  Copyright (c) 2015 Qingxin. All rights reserved.
//

#import "VoiceRecordViewController.h"

#import "BJIConverter.h"
#import "PCMMixer.h"

#define TIMER_INTERVAL  0.5

@interface VoiceRecordViewController ()
{
    BOOL bIsRecord;
    NSURL *urlFilePath;
    NSString *szFileName;
    NSString *szFilePath;
    
    NSString *szMixFileName;
    NSString *szMixFilePath;
    
    NSTimer *recordTimer;
    int timerCount;
    NSMutableArray *arrayTimes;
    NSMutableArray *arrayAlarm;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonRecord;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecordingState;
@property (weak, nonatomic) IBOutlet UILabel *textRecordStatus;

@end

@implementation VoiceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bIsRecord = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getTimes {
    //  First item must be at time 0. All other sounds must be relative to this first sound.
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:40], [NSNumber numberWithInt:90], nil];
}

- (NSArray*)getMP3s {
    //  Find all mp3's in bundle
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
    NSArray *mp3s = [dirContents filteredArrayUsingPredicate:fltr];
    
    //  Convert mp3's to their full paths
    NSMutableArray *fullmp3s = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [fullmp3s addObject:[bundleRoot stringByAppendingPathComponent:file]];
    }];
    
    return fullmp3s;
}

- (NSArray*)getCAFs:(NSArray*)mp3s {
    //  Find 'Documents' directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //  Create AIFFs from mp3's
    NSMutableArray *cafs = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [cafs addObject:[docPath stringByAppendingPathComponent:[[file lastPathComponent] stringByReplacingOccurrencesOfString:@".mp3" withString:@".caf"]]];
    }];
    return cafs;
}

-(NSURL *)recordedFileURL
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(  NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"temp_yyyyMMddHHmmss"];
    NSString *dateInStringFormatted = [dateformatter stringFromDate:[NSDate date]];
    szFileName = [NSString stringWithFormat:@"%@.caf", dateInStringFormatted];
    
    szFilePath = [docsDir stringByAppendingPathComponent:szFileName];
    urlFilePath = [NSURL fileURLWithPath:szFilePath];
    
    return urlFilePath;
}

- (NSString*)getMixURL {
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(  NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateInStringFormatted = [dateformatter stringFromDate:[NSDate date]];
    szMixFileName = [NSString stringWithFormat:@"%@.caf", dateInStringFormatted];
    
    szMixFilePath = [docsDir stringByAppendingPathComponent:szMixFileName];
    
    return szMixFilePath;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRecord:(id)sender {
    if (bIsRecord == NO) {
        bIsRecord = YES;
        
        timerCount = 0;
        arrayAlarm = [NSMutableArray array];
        arrayTimes = [NSMutableArray array];
        
        AVAudioSession* session = [AVAudioSession sharedInstance];
        [session setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];   //mpeg 4 aac
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];             //sample rate
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];              //2 channels
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];             //16 bits
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        NSError *error = nil;    
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self recordedFileURL] settings:recordSetting error:&error];
        
        self.audioRecorder.meteringEnabled = true;
        [self.audioRecorder prepareToRecord];
        
        [session setActive: true error: nil];
        [self.audioRecorder record];
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        
        self.textRecordStatus.text = @"STOP";
        [self.buttonRecord setBackgroundImage:[UIImage imageNamed:@"icon_recording.png"] forState:UIControlStateNormal];
    } else {
        bIsRecord = NO;
        
        if (recordTimer != nil) {
            [recordTimer invalidate];
            recordTimer = nil;
        }
        
        [self.audioRecorder stop];
        self.audioRecorder = nil;
        
        self.textRecordStatus.text = @"START";
        [self.buttonRecord setBackgroundImage:[UIImage imageNamed:@"icon_recorded.png"] forState:UIControlStateNormal];
        
        NSArray *mp3s = [self getMP3s];
        NSArray *cafs = [self getCAFs:mp3s];
        
        [BJIConverter convertFiles:mp3s toFiles:cafs];
        
        NSMutableArray *initFiles = [NSMutableArray arrayWithArray:cafs];
        
        NSMutableArray *files = [NSMutableArray array];
        [files insertObject:szFilePath atIndex:0];
        NSMutableArray *times = [NSMutableArray array];
        [times insertObject:[NSNumber numberWithInt:0] atIndex:0];
        
        for (int i = 0; i < arrayAlarm.count; i++) {
            if ( [[arrayAlarm objectAtIndex:i] integerValue] == 1 ) {
                [files addObject:[initFiles objectAtIndex:1]];
            }
            else {
                [files addObject:[initFiles objectAtIndex:0]];
            }
            
            int nVal = [[arrayTimes objectAtIndex:i] integerValue] * 5;
            [times addObject:[NSNumber numberWithInt:nVal]];
        }
        
        NSString *mixURL = [self getMixURL];
        [PCMMixer mixFiles:files atTimes:times toMixfile:mixURL];
        
        [_delegate didGetVoiceName:szMixFileName path:szMixFilePath];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) handleTimer:(NSTimer *) timer {
    timerCount++;
}

- (IBAction)onPositiveClicked:(id)sender {
    if ( bIsRecord == YES ) {
        [arrayTimes addObject:[NSNumber numberWithInt:timerCount]];
        [arrayAlarm addObject:[NSNumber numberWithInt:1]];
    }
}

- (IBAction)onNegativeClicked:(id)sender {
    if ( bIsRecord == YES ) {
        [arrayTimes addObject:[NSNumber numberWithInt:timerCount]];
        [arrayAlarm addObject:[NSNumber numberWithInt:0]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:@"Thanks"
                          message:@"Your recording has finished" delegate:self
                          cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}
-(void)audioRecorderEncodeErrorDidOccur: (AVAudioRecorder *)recorder error:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:@"Error" message:@"An error has occured"
                          delegate:self cancelButtonTitle:@"Ok" 
                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
