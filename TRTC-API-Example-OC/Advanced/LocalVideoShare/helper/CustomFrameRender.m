//
//  TestRenderCustomVideoData.m
//  TRTC-API-Example-OC
//
//  Created by rushanting on 2019/3/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "CustomFrameRender.h"

@implementation CustomFrameRender

+ (void)clearImageView:(UIImageView*)imageView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize size = imageView.bounds.size;
        if (size.width <= 0 || size.height <= 0) {
            imageView.image = nil;
            return;
        }
        
        UIGraphicsBeginImageContext(size);
        UIColor * color = [UIColor clearColor];
        [color setFill];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        imageView.image = image;
        UIGraphicsEndImageContext();
    });
}

+ (void)renderImageBuffer:(CVImageBufferRef)imageBufer forView:(UIImageView*)imageView {
    CFRetain(imageBufer);
    dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image = [UIImage imageWithCIImage:[CIImage imageWithCVImageBuffer:imageBufer]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CFRelease(imageBufer);
    });
}

@end
