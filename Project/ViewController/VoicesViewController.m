//
//  VoicesViewController.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "VoicesViewController.h"
#import "RecordCell.h"
#import "Voice.h"
#import "Project.h"
#import "ProjectManager.h"
#import "VoiceRecordViewcontroller.h"

@interface VoicesViewController ()

@end

@implementation VoicesViewController
@synthesize recordVoices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithProject: (Project*) project {
    self.currentProject = project;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.currentProject.voices == nil) {
        self.currentProject.voices = [NSMutableArray array];
    }
    self.recordVoices = self.currentProject.voices;
//    lblTitle.font = [UIFont fontWithName: @"BALLPARK" size: 24];
}

- (IBAction) onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) onAddVoice:(id)sender
{
    VoiceRecordViewController *pController = [[VoiceRecordViewController alloc] init];
    pController.delegate = self;
    [self.navigationController pushViewController:pController animated:YES];
//    [InputView showInputWithDelegate: self];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RECORDCELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentProject.voices.count < indexPath.row)
        return;
    
    Voice* tmpVoice = (Voice*)[self.currentProject.voices objectAtIndex:indexPath.row];
    OSStatus status = 1;
    [self playMix:tmpVoice.path withStatus:status];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recordVoices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell* cell = [tableView dequeueReusableCellWithIdentifier: @"RecordCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed: @"RecordCell" owner:nil options: nil] objectAtIndex: 0];
    }
    
    Voice* voice = [self.recordVoices objectAtIndex: indexPath.row];
    [cell resetWithVoice: voice];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.recordVoices removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths: [NSMutableArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
        [[ProjectManager manager] saveToDefaults];
        [tableView setEditing: NO animated: YES];
    }
}

#pragma VoiceRecord Delegate
- (void) didGetVoiceName:szFileName path:(NSString *)szPath {
    Voice* voice = [Voice new];
    voice.title = szFileName;
    voice.path = szPath;
    voice.project = self.currentProject;
    voice.index = [self.currentProject.voices count] + 1;
    
    [self.currentProject.voices addObject:voice];
    [ProjectManager updateProject:self.currentProject];
    
    [tblrecordVoices reloadData];
}

- (void)playMix:(NSString*)mixURL withStatus:(OSStatus)status {
    NSURL *url = [NSURL fileURLWithPath:mixURL];
    
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"wrote mix file of size %d : %@", [urlData length], mixURL);
    
    AVAudioPlayer *avAudioObj = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer = avAudioObj;
    
    [avAudioObj prepareToPlay];
    [avAudioObj play];
}

#pragma delegates
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayer = nil;
}

@end
