//
//  Page.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "Page.h"
#import "Link.h"

@implementation Page
@synthesize title;
@synthesize image;
@synthesize links;
@synthesize project;
@synthesize index;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.project = [aDecoder decodeObjectForKey: @"project"];        
        self.title = [aDecoder decodeObjectForKey: @"title"];
        self.image = [UIImage imageWithData: [aDecoder decodeObjectForKey: @"image"]];
        self.links = [aDecoder decodeObjectForKey: @"links"];
        self.index = [aDecoder decodeIntegerForKey: @"index"];
        
        if (self.links == nil) {
            self.links = [NSMutableArray array];
        }
        for (Link* link in self.links) {
            link.currentPage = self;
        }
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.links = [NSMutableArray array];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    NSData* data = UIImagePNGRepresentation(self.image);
    [aCoder encodeObject: data forKey: @"image"];
    [aCoder encodeObject: self.project forKey: @"project"];    
    [aCoder encodeObject: self.title forKey: @"title"];
    [aCoder encodeObject: self.links forKey: @"links"];
    [aCoder encodeInteger: self.index forKey: @"index"];
}

- (void) removeLinkWithIndex: (NSInteger) nIndex
{
    NSInteger count = [self.links count];
    
    for (int i=count-1; i>=0; i--) {
        Link* link = [self.links objectAtIndex: i];
        if (link.linkedPage == nIndex) {
            [self.links removeObject: link];
        }
    }
}
@end
