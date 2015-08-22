//
//  ProjectManager.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;
@interface ProjectManager : NSObject
@property (nonatomic, strong) NSMutableArray*       projects;

+ (ProjectManager*) manager;

+ (void) addProject: (Project*) project;
+ (BOOL) addProject: (Project*) project atIndex: (NSInteger) index;
+ (void) removeProject: (Project*) project;
+ (BOOL) removeProjectAtIndex: (NSInteger) index;

+ (BOOL) updateProject: (Project *) project;

- (void) loadFromDefaults;
- (void) saveToDefaults;
@end
