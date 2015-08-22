//
//  UIImageResizing.m
//  JPImagePickerController
//
//  Created by Jeena on 07.11.09.
//  Copyright 2009 Jeena Paradies.
//  Licence: MIT-Licence
//

#import "UIImageResizing.h"



static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

@implementation UIImage (Resizing)
double rad(double deg)
{
    return deg / 180.0 * M_PI;
}

-(UIImage *) croppedImage:(CGRect) rect{
    CGAffineTransform rectTransform;
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage: imageRef scale: self.scale orientation: self.imageOrientation];
    CGImageRelease(imageRef);
    return [UIImage image: result scaleAndCroppForSize: CGSizeMake(300, 450)];
}

-(UIImage*)rotate:(UIImageOrientation)orient {
	CGRect             bnds = CGRectZero;
	UIImage*           copy = nil;
	CGContextRef       ctxt = nil; 
    CGImageRef         imag = self.CGImage;
	CGRect             rect = CGRectZero; 
    CGAffineTransform  tran = CGAffineTransformIdentity;
	rect.size.width  = CGImageGetWidth(imag);
	rect.size.height = CGImageGetHeight(imag); 
	bnds = rect;
	
	switch (orient)
	{   
		case UIImageOrientationUp: 
			// would get you an exact copy of the original 
			//assert(false); 
			
			return self; 
		case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0); 
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;         case UIImageOrientationDown: 
			tran = CGAffineTransformMakeTranslation(rect.size.width,   rect.size.height); 
			tran = CGAffineTransformRotate(tran, M_PI); 
			break;
		case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height); 
			tran = CGAffineTransformScale(tran, 1.0, -1.0); 
			break;
		case UIImageOrientationLeft: 
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationLeftMirrored: 
			bnds = swapWidthAndHeight(bnds); 
			tran = CGAffineTransformMakeTranslation(rect.size.height, rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationRight:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
		case UIImageOrientationRightMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
		default: 
			// orientation value supplied is invalid 
        //assert(false);
		return self;
	}  
	UIGraphicsBeginImageContext(bnds.size);
	ctxt = UIGraphicsGetCurrentContext();
	switch (orient)  
	{  
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight: 
        case UIImageOrientationRightMirrored: 
        CGContextScaleCTM(ctxt, -1.0, 1.0);
		CGContextTranslateCTM(ctxt, -rect.size.height, 0.0); 
        break;  
		default:  
		CGContextScaleCTM(ctxt, 1.0, -1.0); 
        CGContextTranslateCTM(ctxt, 0.0, -rect.size.height); 
        break;
	}   
	CGContextConcatCTM(ctxt, tran); 
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
	copy = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    return copy;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImageNew:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImageNew:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}
// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;

	/*
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    */
    return transform;
}


- (UIImage *)resizedImageNew:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality

{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}


+ (UIImage *)image:(UIImage *)sourceImage scaleAndCroppForSize:(CGSize)targetSize {

	UIImage *newImage = nil;        
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor >= heightFactor) {
			scaleFactor = widthFactor; // scale to fit height
        } else {
			scaleFactor = heightFactor; // scale to fit width
		}
		
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor >= heightFactor)	{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		} else if (widthFactor < heightFactor)	{
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}       
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil) 
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *)scaleAndCropToSize:(CGSize)targetSize {
	return [UIImage image:self scaleAndCroppForSize:(CGSize)targetSize];
}

- (UIImage *)scaleAndCropToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded {
	
	UIImage *image;
	
	if (!onlyIfNeeded || [self needsToScale:targetSize]) {
		image = [self scaleAndCropToSize:targetSize];
	} else {
		image = self;
	}
	
	return image;
}

+ (UIImage *)image:(UIImage *)sourceImage scaleToSize:(CGSize)targetSize {
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetSize.width;
	CGFloat scaledHeight = targetSize.height;
	
	CGFloat widthFactor = targetSize.width / sourceImage.size.width;
	CGFloat heightFactor = targetSize.height / sourceImage.size.height;

	if (widthFactor < heightFactor) {
		scaleFactor = widthFactor; // scale to fit height
	} else {
		scaleFactor = heightFactor; // scale to fit width
	}
		
	scaledWidth  = sourceImage.size.width * scaleFactor;
	scaledHeight = sourceImage.size.height * scaleFactor;
	
	CGSize propperSize = CGSizeMake(scaledWidth, scaledHeight);
	
	UIGraphicsBeginImageContext( propperSize );
	[sourceImage drawInRect:CGRectMake(0, 0, propperSize.width, propperSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *)scaleToSize:(CGSize)newSize {
	return [UIImage image:self scaleToSize:newSize];
}

- (UIImage *)scaleToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded {
	
	UIImage *image;
	
	if (!onlyIfNeeded || [self needsToScale:targetSize]) {
		image = [self scaleToSize:targetSize];
	} else {
		image = self;
	}
	
	return image;
}

+ (BOOL)image:(UIImage *)sourceImage needsToScale:(CGSize)targetSize {
	BOOL needsToScale = NO;
	
	if (sourceImage.size.width > targetSize.width) {
		needsToScale = YES;
	}
	
	if (sourceImage.size.height > targetSize.height) {
		needsToScale = YES;
	}
	
	return needsToScale;
}

- (BOOL)needsToScale:(CGSize)targetSize {
	return [UIImage image:self needsToScale:targetSize];
}

- (void) addRoundedRectToPath:(CGContextRef) context : (CGRect) rect : (float) ovalWidth : (float) ovalHeight
{
	float fw, fh;
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	CGContextSaveGState(context);
	CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM (context, ovalWidth, ovalHeight);
	fw = CGRectGetWidth (rect) / ovalWidth;
	fh = CGRectGetHeight (rect) / ovalHeight;
	CGContextMoveToPoint(context, fw, fh/2);
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

-(UIImage*)MakeImageIntoRoundRect:(UIImage *)image : (CGRect) rect
{
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGGraphicsSaveGState(context);
	[self addRoundedRectToPath:context :rect :10 :10];
	// (context, rect, 10, 10);
	CGContextClip(context);
	[image drawInRect:rect];
	UIGraphicsEndImageContext();
	//CGContextRestoreGState(context);
	return image;
}

@end
