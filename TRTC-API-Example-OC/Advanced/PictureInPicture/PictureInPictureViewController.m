//
//  PictureInPictureViewController.m
//  TRTC-API-Example-OC
//
//  Created by adams on 2022/8/17.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "PictureInPictureViewController.h"
#import <AVKit/AVKit.h>

/*
 画中画功能（iOS15及以上支持）
 MLVB APP 画中画功能代码示例：
 本文件展示如何通过移动直播SDK实现iOS系统上的画中画功能
 1、开启本地自定义渲染 API: [self.trtcCloud setLocalVideoRenderDelegate:self pixelFormat:TRTCVideoPixelFormat_NV12 bufferType:TRTCVideoBufferType_PixelBuffer];
 2、需要开启SDK的后台解码能力 API:
```
    NSDictionary *param = @{
        @"api" : @"enableBackgroundDecoding",
        @"params" : @{
            @"enable" : @(YES)
        }
    };

    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&err];
    if (err) {
        NSAssert(NO, err.description);
        NSLog(@"【ToolkitBase】Dic to json str error:%@", err);
        return;
    }
    NSString *paramJsonString = [[NSString alloc] initWithData:jsonData
                                                      encoding:NSUTF8StringEncoding];
    [self.trtcCloud callExperimentalAPI:paramJsonString];
 ```
 3、使用系统 API创建画中画内容源: AVPictureInPictureControllerContentSource *contentSource = [[AVPictureInPictureControllerContentSource alloc] initWithSampleBufferDisplayLayer:self.sampleBufferDisplayLayer playbackDelegate:self];;
 4、使用系统 API创建画中画控制器: [[AVPictureInPictureController alloc] initWithContentSource:contentSource];
 5、在SDK回调:- (void)onRenderVideoFrame:(TRTCVideoFrame *)frame userId:(NSString *)userId streamType:(TRTCVideoStreamType)streamType内将pixelBuffer转为SampleBuffer并交给AVSampleBufferDisplayLayer进行渲染;
 6、使用系统 API开启画中画功能：[self.pipViewController startPictureInPicture];
 */

/// 画中画功能演示，示例拉流地址。
@interface PictureInPictureViewController ()<
TRTCCloudDelegate,
TRTCVideoRenderDelegate,
AVPictureInPictureControllerDelegate,
AVPictureInPictureSampleBufferPlaybackDelegate
>
@property (strong, nonatomic) TRTCCloud *trtcCloud;
@property (nonatomic, strong) AVPictureInPictureController *pipViewController;
@property (nonatomic, strong) AVSampleBufferDisplayLayer *sampleBufferDisplayLayer;

@property (weak, nonatomic) IBOutlet UIButton *pictureInPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *startPushButton;
@property (weak, nonatomic) IBOutlet UILabel *roomIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *roomIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnConstraint;
@end

@implementation PictureInPictureViewController

- (TRTCCloud *)trtcCloud {
    if (!_trtcCloud) {
        _trtcCloud = [TRTCCloud sharedInstance];
    }
    return _trtcCloud;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.trtcCloud exitRoom];
    self.pipViewController = nil;
    self.trtcCloud = nil;
    [self.sampleBufferDisplayLayer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultUIConfig];
    
    if (@available(iOS 15.0, *)) {
        if ([AVPictureInPictureController isPictureInPictureSupported]) {
            //开启画中画后台声音权限
            NSError *error = nil;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            if (error) {
                NSLog(@"%@%@",localize(@"TRTC-API-Example.PictureInPicture.PermissionFailed"),error);
            }
            [self setupSampleBufferDisplayLayer];
            [self.view.layer insertSublayer:self.sampleBufferDisplayLayer atIndex:0];
            AVPictureInPictureControllerContentSource *contentSource = [[AVPictureInPictureControllerContentSource alloc]
                                                                        initWithSampleBufferDisplayLayer:self.sampleBufferDisplayLayer
                                                                        playbackDelegate:self];
            self.pipViewController = [[AVPictureInPictureController alloc] initWithContentSource:contentSource];
            self.pipViewController.delegate = self;
            self.pipViewController.canStartPictureInPictureAutomaticallyFromInline = YES;
        } else {
            NSLog(@"%@",localize(@"TRTC-API-Example.PictureInPicture.NotSupported"));
        }
    }
}

- (void)setupDefaultUIConfig {
   
    self.roomIDLabel.text = localize(@"TRTC-API-Example.CustomCamera.roomId");
    self.userIDLabel.text = localize(@"TRTC-API-Example.CustomCamera.userId");
    self.roomIDTextField.text = [NSString generateRandomRoomNumber];
    self.userIDTextField.text= [NSString generateRandomUserId];
    UIImage *backgroundImage = [[UIColor themeGreenColor] trans2Image:CGSizeMake(1, 1)];
    [self.startPushButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self.startPushButton setTitle:localize(@"TRTC-API-Example.CustomCamera.startPush")
                          forState:UIControlStateNormal];
    [self.startPushButton setTitle:localize(@"TRTC-API-Example.CustomCamera.stopPush") forState:UIControlStateSelected];
    [self.pictureInPictureButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self.pictureInPictureButton setTitle:localize(@"TRTC-API-Example.PictureInPicture.OpenPictureInPicture") forState:UIControlStateNormal];
    [self refreshViewTitle];
}

- (void)refreshViewTitle {
    self.title = localizeReplace(localize(@"TRTC-API-Example.CustomCamera.viewTitle"), self.roomIDTextField.text);
}

- (void)enterRoom {
    // Enter trtc room.
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = SDKAppID;
    params.roomId = [self.roomIDTextField.text intValue];
    params.userId = self.userIDTextField.text;
    params.userSig = [GenerateTestUserSig genTestUserSig:self.userIDTextField.text];
    params.role = TRTCRoleAnchor;
    self.trtcCloud.delegate = self;
    [self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
    [self.trtcCloud startLocalAudio:TRTCAudioQualityMusic];
    [self.trtcCloud setLocalVideoRenderDelegate:self
                                    pixelFormat:TRTCVideoPixelFormat_NV12
                                     bufferType:TRTCVideoBufferType_PixelBuffer];
    [self.trtcCloud startLocalPreview:YES view:nil];
    NSDictionary *param = @{
        @"api" : @"enableBackgroundDecoding",
        @"params" : @{
            @"enable" : @(YES)
        }
    };
    
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&err];
    if (err) {
        NSAssert(NO, err.description);
        NSLog(@"【ToolkitBase】Dic to json str error:%@", err);
        return;
    }
    NSString *paramJsonString = [[NSString alloc] initWithData:jsonData
                                                      encoding:NSUTF8StringEncoding];
    [self.trtcCloud callExperimentalAPI:paramJsonString];
}

- (void)exitRoom {
    [self.trtcCloud exitRoom];
    [self.sampleBufferDisplayLayer flushAndRemoveImage];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.roomIDTextField.isFirstResponder) {
        [self.roomIDTextField resignFirstResponder];
    }
    if (self.userIDTextField.isFirstResponder) {
        [self.userIDTextField resignFirstResponder];
    }
}

- (IBAction)onPictureInPictureButtonClick:(id)sender {
    //在点击画中画按钮的时候 开启画中画
    if (self.pipViewController.isPictureInPictureActive) {
        [self.pipViewController stopPictureInPicture];
    } else {
        [self.pipViewController startPictureInPicture];
    }
}

- (IBAction)onStartPushButtonClick:(UIButton *)sender {
    if (self.roomIDTextField.text.length == 0) {
        return;
    }
    if (self.userIDTextField.text.length == 0) {
        return;
    }
    sender.selected = !sender.selected;
    sender.enabled = NO;
    if (sender.selected) {
        [self refreshViewTitle];
        [self enterRoom];
    } else {
        [self exitRoom];
    }
}

//把pixelBuffer包装成samplebuffer送给displayLayer
- (void)dispatchPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (!pixelBuffer) {
        return;
    }
    //不设置具体时间信息
    CMSampleTimingInfo timing = {kCMTimeInvalid, kCMTimeInvalid, kCMTimeInvalid};
    //获取视频信息
    CMVideoFormatDescriptionRef videoInfo = NULL;
    OSStatus result = CMVideoFormatDescriptionCreateForImageBuffer(NULL, pixelBuffer, &videoInfo);
    NSParameterAssert(result == 0 && videoInfo != NULL);
    
    CMSampleBufferRef sampleBuffer = NULL;
    result = CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault,pixelBuffer, true, NULL, NULL, videoInfo, &timing, &sampleBuffer);
    NSParameterAssert(result == 0 && sampleBuffer != NULL);
    CFRelease(videoInfo);
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, YES);
    CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
    CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
    [self enqueueSampleBuffer:sampleBuffer toLayer:self.sampleBufferDisplayLayer];
    CFRelease(sampleBuffer);
}

- (void)enqueueSampleBuffer:(CMSampleBufferRef)sampleBuffer toLayer:(AVSampleBufferDisplayLayer*)layer {
    if (sampleBuffer) {
        CFRetain(sampleBuffer);
        [layer enqueueSampleBuffer:sampleBuffer];
        CFRelease(sampleBuffer);
        if (layer.status == AVQueuedSampleBufferRenderingStatusFailed) {
            NSLog(@"%@%@",localize(@"TRTC-API-Example.PictureInPicture.Errormessage"),layer.error);
            if (-11847 == layer.error.code) {
                [self rebuildSampleBufferDisplayLayer];
            }
        }
    } else {
        NSLog(@"%@",localize(@"TRTC-API-Example.PictureInPicture.Ignorenullsamplebuffer"));
    }
}

- (void)rebuildSampleBufferDisplayLayer {
    @synchronized(self) {
        [self teardownSampleBufferDisplayLayer];
        [self setupSampleBufferDisplayLayer];
    }
}
  
- (void)teardownSampleBufferDisplayLayer {
    if (self.sampleBufferDisplayLayer) {
        [self.sampleBufferDisplayLayer stopRequestingMediaData];
        [self.sampleBufferDisplayLayer removeFromSuperlayer];
        self.sampleBufferDisplayLayer = nil;
    }
}
  
- (void)setupSampleBufferDisplayLayer {
    if (!self.sampleBufferDisplayLayer) {
        self.sampleBufferDisplayLayer = [[AVSampleBufferDisplayLayer alloc] init];
        self.sampleBufferDisplayLayer.frame = UIApplication.sharedApplication.keyWindow.bounds;
        self.sampleBufferDisplayLayer.position = CGPointMake(CGRectGetMidX(self.sampleBufferDisplayLayer.bounds),
                                                             CGRectGetMidY(self.sampleBufferDisplayLayer.bounds));
        self.sampleBufferDisplayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.sampleBufferDisplayLayer.opaque = YES;
        [self.view.layer insertSublayer:self.sampleBufferDisplayLayer atIndex:0];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.sampleBufferDisplayLayer.frame = self.view.bounds;
        self.sampleBufferDisplayLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        [CATransaction commit];
    }
}

#pragma mark - TRTCVideoRenderDelegate
- (void)onRenderVideoFrame:(TRTCVideoFrame *)frame userId:(NSString *)userId streamType:(TRTCVideoStreamType)streamType {
    if (frame.bufferType != TRTCVideoBufferType_Texture && frame.pixelFormat != TRTCVideoPixelFormat_Texture_2D) {
        [self dispatchPixelBuffer:frame.pixelBuffer];
    }
}

#pragma mark - TRTCCloudDelegate
- (void)onExitRoom:(NSInteger)reason {
    if (!self.startPushButton.isEnabled) {
        self.startPushButton.enabled = YES;
    }
}

- (void)onEnterRoom:(NSInteger)result {
    if (!self.startPushButton.isEnabled) {
        self.startPushButton.enabled = YES;
    }
}

#pragma mark - AVPictureInPictureControllerDelegate
- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"pictureInPictureControllerWillStartPictureInPicture");
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    [self.pictureInPictureButton setTitle:localize(@"TRTC-API-Example.PictureInPicture.ClosePictureInPicture") forState:UIControlStateNormal];
    NSLog(@"pictureInPictureControllerDidStartPictureInPicture");
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"failedToStartPictureInPictureWithError");
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"restoreUserInterfaceForPictureInPictureStopWithCompletionHandler");
    // 执行回调的闭包
    completionHandler(true);
}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"pictureInPictureControllerWillStopPictureInPicture");
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    [self.pictureInPictureButton setTitle:localize(@"TRTC-API-Example.PictureInPicture.OpenPictureInPicture") forState:UIControlStateNormal];
    NSLog(@"pictureInPictureControllerDidStopPictureInPicture");
}


#pragma mark - AVPictureInPictureSampleBufferPlaybackDelegate
- (BOOL)pictureInPictureControllerIsPlaybackPaused:(nonnull AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"pictureInPictureControllerIsPlaybackPaused");
    return NO;
}

- (CMTimeRange)pictureInPictureControllerTimeRangeForPlayback:(AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"pictureInPictureControllerTimeRangeForPlayback");
    return  CMTimeRangeMake(kCMTimeZero, kCMTimePositiveInfinity); // for live streaming
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
         didTransitionToRenderSize:(CMVideoDimensions)newRenderSize {
    NSLog(@"didTransitionToRenderSize");
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController setPlaying:(BOOL)playing {
    NSLog(@"setPlaying");
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController
                    skipByInterval:(CMTime)skipInterval
                 completionHandler:(void (^)(void))completionHandler {
    NSLog(@"skipByInterval");
}

@end
