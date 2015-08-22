//
//  ProfilePhotoTakeViewController.m
//  WallCalendar
//
//  Created by Optiplex790 on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoTakeViewController.h"
#import "UIImageResizing.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_WIDTH         133.3f
#define IMAGE_HEIGHT         133.3f

@interface PhotoTakeViewController ()

@end

@implementation PhotoTakeViewController
@synthesize lblTitle;
@synthesize image;
@synthesize imgView;
@synthesize scrollImage;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.scrollImage.layer.cornerRadius = 10.0f;
    self.scrollImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.scrollImage.layer.borderWidth = 1.0f;
//    self.lblTitle.font = [UIFont fontWithName: @"BALLPARK" size: 24];

    CGRect rtScroll;
    rtScroll.size.height = [[UIScreen mainScreen] applicationFrame].size.height - 240;
    rtScroll.size.width = rtScroll.size.height / 1.5f;
    rtScroll.origin.x = (320 - rtScroll.size.width) / 2;
    rtScroll.origin.y = 70;
    scrollImage.frame = rtScroll;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) onCamera:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    UIImagePickerController* pController = [UIImagePickerController new];
    pController.delegate = self;
    pController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController: pController animated: YES completion: nil];
}

- (IBAction) onPhotoLibrary:(id)sender
{
    UIImagePickerController* pController = [UIImagePickerController new];
    pController.delegate = self;
    pController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController: pController animated: YES completion: nil];
}

- (UIImage*) cropCurrentImage
{
    CGSize size = self.image.size;
    
    CGRect rtToBeCropped;
    NSLog(@"ContentOffset: x(%f), y(%f) ||| Scale: %f, OriginalImage: %f, %f", scrollImage.contentOffset.x, scrollImage.contentOffset.y, scrollImage.zoomScale, size.width, size.height);
    rtToBeCropped.origin = CGPointMake(scrollImage.contentOffset.x / scrollImage.zoomScale, scrollImage.contentOffset.y / scrollImage.zoomScale);
    rtToBeCropped.size = CGSizeMake(scrollImage.frame.size.width / scrollImage.zoomScale, scrollImage.frame.size.height / scrollImage.zoomScale);
    
    return [self.image croppedImage: rtToBeCropped];
}

- (IBAction) onDone:(id)sender
{
    if (self.image != nil && self.delegate != nil) {
        UIImage* imgCropped = [self cropCurrentImage];
        [self.delegate photoTaken: imgCropped];
    }
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)takenImage editingInfo:(NSDictionary *)editingInfo
{
    self.image = takenImage;
    self.imgView.image = self.image;
    CGSize size = self.image.size;
    self.imgView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.scrollImage setContentSize: size];
    [self.scrollImage setContentOffset: CGPointMake( (size.width - scrollImage.frame.size.width)/2, (size.height - scrollImage.frame.size.height)/2)];
    
    [picker dismissModalViewControllerAnimated: YES];
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

@end
