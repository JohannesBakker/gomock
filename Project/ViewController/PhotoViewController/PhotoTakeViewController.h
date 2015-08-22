//
//  ProfilePhotoTakeViewController.h
//  WallCalendar
//
//  Created by Optiplex790 on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoTakeViewControllerDelegate <NSObject>
- (void) photoTaken: (UIImage*) image;
@end

@interface PhotoTakeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UILabel*                          lblTitle;
@property (nonatomic, strong) IBOutlet UIImageView*                      imgView;
@property (nonatomic, strong) IBOutlet UIScrollView*                     scrollImage;
@property (nonatomic, strong) UIImage*                                   image;
@property (nonatomic, strong) id<PhotoTakeViewControllerDelegate> delegate;
@end
