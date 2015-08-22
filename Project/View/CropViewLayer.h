//
//  CropViewLayer.h
//  Project
//
//  Created by Mountain on 6/17/13.
//  Copyright (c) 2013 Qingxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    WITHOUT_LINK,
    WITH_LINK
} eCropLayerType;

@interface CropViewLayer : UIView
{
    CGRect _cropRect;
    UIImageView* leftTopCorner;
    UIImageView* leftBottomCorner;
    UIImageView* rightTopCorner;
    UIImageView* rightBottomCorner;
    UIView*      backgroundView;
}

@property (nonatomic, assign) NSInteger     cropLayerType;
@property (nonatomic, assign) BOOL          isInEditing;
@property (nonatomic, strong) id            link;
@end
