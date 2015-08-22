//
//  Project.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "Project.h"
#import "Page.h"
#import "Voice.h"

@implementation Project
@synthesize title;
@synthesize pages;
@synthesize voices;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey: @"title"];
        self.pages = [aDecoder decodeObjectForKey: @"pages"];
        if (self.pages == nil) {
            self.pages = [NSMutableArray array];
        }
        for (Page* page in self.pages) {
            page.project = self;
        }
        self.voices = [aDecoder decodeObjectForKey: @"voices"];
        if (self.voices == nil) {
            self.voices = [NSMutableArray array];
        }
        for (Voice* voice in self.voices) {
            voice.project = self;
        }
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.pages = [NSMutableArray array];
        self.voices = [NSMutableArray array];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.title forKey: @"title"];
    [aCoder encodeObject: self.pages forKey: @"pages"];
    [aCoder encodeObject: self.voices forKey:@"voices"];
}

@end
