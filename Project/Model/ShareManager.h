//
//  ShareManager.h
//  Project
//
//  Created by Mountain on 6/24/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@class Project;
@class ZipArchive;
@interface ShareManager : NSObject <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) Project*      currentProject;
@property (nonatomic, strong) ZipArchive*   currentArchive;

+ (ShareManager*) manager;
+ (void) shareProject: (Project*) project;
- (void) appendPagesToZip;

@end
