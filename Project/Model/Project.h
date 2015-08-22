//
//  Project.h
//  Project
//
//  Created by Mountain on 6/14/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject <NSCoding>
@property (nonatomic, strong) NSString*         title;
@property (nonatomic, strong) NSMutableArray*   pages;
@property (nonatomic, strong) NSMutableArray*   voices;
@end
