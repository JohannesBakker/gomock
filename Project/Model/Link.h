//
//  Link.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Page;
@interface Link : NSObject <NSCoding>
@property (nonatomic, assign) CGRect            rectInPage;
@property (nonatomic, assign) Page*         currentPage;
@property (nonatomic, assign) NSInteger         linkedPage;

- (NSComparisonResult) compare: (Link*) link;

@end
