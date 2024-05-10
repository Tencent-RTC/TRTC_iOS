//
//  TestRenderCustomVideoData.m
//  TXLiteAVDemo
//
//  Created by rushanting on 2019/3/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "CustomCameraFrameRender.h"

@interface CustomCameraFrameRender ()
@property (nonatomic, strong) UIImageView* localVideoView;
@property (nonatomic, strong) NSMutableDictionary* userVideoViews;
@property (strong, nonatomic) dispatch_queue_t queue;
@end

@implementation CustomCameraFrameRender

- (instancetype)init
{
    if (self = [super init]) {
        _userVideoViews = [NSMutableDictionary new];
        _queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)start:(NSString *)userId videoView:(UIImageView *)videoView
{
    // userId is nil for self
    if (!userId) {
        _localVideoView = videoView;
    }
    else {
        [_userVideoViews setObject:videoView forKey:userId];
    }
}
 
- (void)stop {
    UIGraphicsBeginImageContext(_localVideoView.bounds.size);
    UIColor * color = [UIColor clearColor];
    [color setFill];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _localVideoView.image = image;
}

- (void)onRenderVideoFrame:(TRTCVideoFrame *)frame userId:(NSString *)userId streamType:(TRTCVideoStreamType)streamType
{
    // When userId is nil, it is the local screen, otherwise it is the remote screen.
    CFRetain(frame.pixelBuffer);
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        CustomCameraFrameRender* strongSelf = weakSelf;
        UIImageView* videoView = nil;
        if (userId) {
            videoView = [strongSelf.userVideoViews objectForKey:userId];
        }
        else {
            videoView = strongSelf.localVideoView;
        }
        videoView.image = [UIImage imageWithCIImage:[CIImage imageWithCVImageBuffer:frame.pixelBuffer]];
        videoView.contentMode = UIViewContentModeScaleAspectFit;
        CFRelease(frame.pixelBuffer);
    });
}

@end
