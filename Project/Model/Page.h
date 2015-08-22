//
//  Page.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;
@interface Page : NSObject <NSCoding>
@property (nonatomic, strong) Project*              project;
@property (nonatomic, assign) NSInteger             index;
@property (nonatomic, strong) NSString*             title;
@property (nonatomic, strong) UIImage*              image;
@property (nonatomic, strong) NSMutableArray*       links;

- (void) removeLinkWithIndex: (NSInteger) index;
@end
