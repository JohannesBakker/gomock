//
//  Link.m
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import "Link.h"

@implementation Link
@synthesize rectInPage;
@synthesize currentPage;
@synthesize linkedPage;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.rectInPage = [aDecoder decodeCGRectForKey: @"rectInPage"];
        self.linkedPage = [aDecoder decodeIntegerForKey: @"linkedPage"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGRect: self.rectInPage forKey: @"rectInPage"];
    [aCoder encodeInteger: self.linkedPage forKey: @"linkedPage"];
}

- (NSComparisonResult) compare: (Link*) link
{
    if (CGRectEqualToRect(self.rectInPage, CGRectZero)) {
        return NSOrderedAscending;
    }
    
    if (CGRectEqualToRect(self.rectInPage, link.rectInPage)) {
        return NSOrderedSame;
    }
    
    int x1 = self.rectInPage.origin.x;
    int y1 = self.rectInPage.origin.y;
    int x2 = link.rectInPage.origin.x;
    int y2 = link.rectInPage.origin.y;
    
    if (y1 < y2) {
        return NSOrderedAscending;
    }
    else if (y1 == y2)
    {
        if (x1 < x2) {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }
    else
    {
        return NSOrderedDescending;
    }
}
@end
