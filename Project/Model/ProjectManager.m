//
//  ProjectManager.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "ProjectManager.h"
#import "Project.h"

@implementation ProjectManager
static ProjectManager* sharedInstance = nil;
@synthesize projects;

+ (ProjectManager*) manager
{
    if (sharedInstance == nil) {
        sharedInstance = [ProjectManager new];
    }
    return sharedInstance;
}

+ (void) addProject: (Project*) project
{
    ProjectManager* manager = [ProjectManager manager];
    [manager.projects addObject: project];
    [manager saveToDefaults];
}

+ (BOOL) addProject: (Project*) project atIndex: (NSInteger) index
{
    ProjectManager* manager = [ProjectManager manager];
    if (index > [manager.projects count] || index < 0) {
        return NO;
    }
    
    [manager.projects insertObject: project atIndex: index];
    [manager saveToDefaults];
    return YES;
}

+ (BOOL) updateProject:(Project *)project {
    ProjectManager* manager = [ProjectManager manager];
    int nIndex = 0;
    for (Project * proj in manager.projects) {
        nIndex ++;
        if ( [proj.title isEqualToString:project.title] == YES ) {
            [ProjectManager removeProject:proj];
            break;
        }
    }
    
    [ProjectManager addProject:project atIndex:nIndex-1];
}

+ (void) removeProject: (Project*) project
{
    ProjectManager* manager = [ProjectManager manager];
    [manager.projects removeObject: project];
    [manager saveToDefaults];
}

+ (BOOL) removeProjectAtIndex: (NSInteger) index
{
    ProjectManager* manager = [ProjectManager manager];
    if (index > [manager.projects count] || index < 0 ) {
        return NO;
    }
    [manager.projects removeObjectAtIndex: index];
    [manager saveToDefaults];
    return YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadFromDefaults];
    }
    return self;
}

- (void) loadFromDefaults
{
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];    
    NSArray* projectData = [NSArray arrayWithArray: [standard objectForKey: @"Projects"]];
    
    self.projects = [NSMutableArray array];
    for (NSData* archive in projectData) {
        Project* project = [NSKeyedUnarchiver unarchiveObjectWithData: archive];
        [self.projects addObject: project];
    }
}

- (void) saveToDefaults
{
    NSMutableArray* projectData = [NSMutableArray array];
    for (Project* project in self.projects) {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject: project];
        [projectData addObject: data];
    }
    
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    [standard setObject: projectData forKey: @"Projects"];
    [standard synchronize];
}

@end

