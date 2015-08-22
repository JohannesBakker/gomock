//
//  Voice.h
//  Voice
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;
@interface Voice : NSObject <NSCoding>
@property (nonatomic, strong) Project*              project;
@property (nonatomic, assign) NSInteger             index;
@property (nonatomic, strong) NSString*             title;
@property (nonatomic, strong) NSString*             path;

@end
