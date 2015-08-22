//
//  Voice.m
//  Voice
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "Voice.h"

@implementation Voice
@synthesize project;
@synthesize index;
@synthesize title;
@synthesize path;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.project = [aDecoder decodeObjectForKey: @"project"];
        self.title = [aDecoder decodeObjectForKey: @"title"];
        self.path = [aDecoder decodeObjectForKey: @"path"];
        self.index = [aDecoder decodeIntegerForKey: @"index"];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.project forKey: @"project"];
    [aCoder encodeObject: self.title forKey: @"title"];
    [aCoder encodeObject: self.path forKey: @"path"];
    [aCoder encodeInteger: self.index forKey: @"index"];
}

@end
