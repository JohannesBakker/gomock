//
//  UIImageResizing.h
//  JPImagePickerController
//
//  Created by Jeena on 07.11.09.
//  Copyright 2009 Jeena Paradies.
//  Licence: MIT-Licence
//
//  Most of this code is from http://stackoverflow.com/questions/603907/uiimage-resize-then-crop

#import <Foundation/Foundation.h>


@interface UIImage (Resize)

-(UIImage *) croppedImage:(CGRect) rect;

+ (UIImage *)image:(UIImage *)sourceImage scaleAndCroppForSize:(CGSize)targetSize;
- (UIImage *)scaleAndCropToSize:(CGSize)newSize;
- (UIImage *)scaleAndCropToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded;

+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)newSize;
- (UIImage *)scaleToSize:(CGSize)newSize;
- (UIImage *)scaleToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded;

+ (BOOL)image:(UIImage *)sourceImage needsToScale:(CGSize)targetSize;
- (BOOL)needsToScale:(CGSize)targetSize;
- (void) addRoundedRectToPath:(CGContextRef) context :(CGRect) rect :(float) ovalWidth : (float) ovalHeight;
-(UIImage*)MakeImageIntoRoundRect:(UIImage *)image : (CGRect) rect;
-(UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage *)resizedImageNew:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
		interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageNew:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality ;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end
