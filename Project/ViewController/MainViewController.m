//
//  MainViewController.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "MainViewController.h"
#import "ProjectViewController.h"
#import "ProjectCell.h"
#import "ProjectManager.h"
#import "Project.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize projects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.projects = [ProjectManager manager].projects;
//    lblTitle.font = [UIFont fontWithName: @"BALLPARK" size: 24];
}

- (IBAction) onEditProjects:(id)sender
{
    [tblProjects setEditing: !tblProjects.isEditing animated: YES];
}

- (IBAction) onCreateProject:(id)sender
{
    CreateProjectViewController *pController = [[CreateProjectViewController alloc] init];
    pController.delegate = self;
    [self.navigationController pushViewController:pController animated:YES];
//    [InputView showInputWithDelegate: self];
}

#pragma CreateProject Delegate
- (void) didGetProjectName:(NSString *)projectName {
    Project* project = [Project new];
    project.title = projectName;
    [self.projects addObject: project];
    [[ProjectManager manager] saveToDefaults];
    [tblProjects reloadData];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PROJECTCELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Project* project = [self.projects objectAtIndex: indexPath.row];
    ProjectViewController* pController = [[ProjectViewController alloc] initWithProject: project];
    [self.navigationController pushViewController: pController animated: YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell* cell = [tableView dequeueReusableCellWithIdentifier: @"ProjectCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed: @"ProjectCell" owner:nil options: nil] objectAtIndex: 0];
    }
    
    Project*   project = [self.projects objectAtIndex: indexPath.row];
    [cell resetWithProject: project];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.projects removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths: [NSMutableArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
        [[ProjectManager manager] saveToDefaults];
        [tableView setEditing: NO animated: YES];
    }
}

@end
