//
//  VideoCallingViewController.m
//  TRTC-API-Example-OC
//
//  Created by bluedang on 2021/4/12.
//  Copyright © 2021 Tencent. All rights reserved.
//

/*
Real-Time Audio Call
 TRTC Audio Call
 This document shows how to integrate the real-time audio call feature.
 1. Switch between the speaker and receiver: [[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteSpeakerphone]
 2. Mute the device so that others won’t hear the audio of the device: [_trtcCloud muteLocalAudio:true]
 3. Display other network and volume information: delegate -> onNetworkQuality, onUserVoiceVolume
 Documentation: https://cloud.tencent.com/document/product/647/42046
*/

#import "VideoCallingViewController.h"

static const NSInteger maxRemoteUserNum = 6;

@interface VideoCallingViewController ()<TRTCCloudDelegate>

@property (weak, nonatomic) IBOutlet UILabel *videoOptionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioOptionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchCamButton;
@property (weak, nonatomic) IBOutlet UIButton *captureCamButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *hansFreeButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *remoteViewArr;

@property (assign, nonatomic) UInt32 roomId;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) TRTCCloud *trtcCloud;
@property (strong, nonatomic) NSMutableOrderedSet *remoteUidSet;
@property (assign, nonatomic) BOOL isFrontCamera;
@end

@implementation VideoCallingViewController

- (TRTCCloud*)trtcCloud {
    if (!_trtcCloud) {
        _trtcCloud = [TRTCCloud sharedInstance];
    }
    return _trtcCloud;
}

- (NSMutableOrderedSet *)remoteUidSet {
    if (!_remoteUidSet) {
        _remoteUidSet = [[NSMutableOrderedSet alloc] initWithCapacity:maxRemoteUserNum];
    }
    return _remoteUidSet;
}

- (instancetype)initWithRoomId:(UInt32)roomId userId:(NSString *)userId {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _roomId = roomId;
        _userId = userId;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isFrontCamera = YES;
    self.trtcCloud.delegate = self;

    [self setupDefaultUIConfig];
    [self setupTRTCCloud];
    
    [self.view sendSubviewToBack:self.view];
}

- (void)setupDefaultUIConfig {
    self.title = [localize(@"TRTC-API-Example.VideoCalling.Title") stringByAppendingString:[@(_roomId)stringValue]];
    _videoOptionsLabel.text = localize(@"TRTC-API-Example.VideoCalling.videoOptions");
    _audioOptionsLabel.text = localize(@"TRTC-API-Example.VideoCalling.audioOptions");
    [_hansFreeButton setTitle:localize(@"TRTC-API-Example.VideoCalling.speaker")
                     forState:UIControlStateNormal];
    [_captureCamButton setTitle:localize(@"TRTC-API-Example.VideoCalling.openCam")
                       forState:UIControlStateSelected];
    [_captureCamButton setTitle:localize(@"TRTC-API-Example.VideoCalling.closeCam")
                       forState:UIControlStateNormal];
    [_muteButton setTitle:localize(@"TRTC-API-Example.VideoCalling.cancelMute")
                 forState:UIControlStateSelected];
    [_muteButton setTitle:localize(@"TRTC-API-Example.VideoCalling.mute")
                 forState:UIControlStateNormal];
    [_hansFreeButton setTitle:localize(@"TRTC-API-Example.VideoCalling.earPhone")
                     forState:UIControlStateNormal];
    [_hansFreeButton setTitle:localize(@"TRTC-API-Example.VideoCalling.speaker")
                     forState:UIControlStateSelected];
    [_switchCamButton setTitle:localize(@"TRTC-API-Example.VideoCalling.useBehindCam")
                      forState:UIControlStateNormal];
    [_switchCamButton setTitle:localize(@"TRTC-API-Example.VideoCalling.useFrontCam")
                      forState:UIControlStateSelected];
    _videoOptionsLabel.adjustsFontSizeToFitWidth = true;
    _audioOptionsLabel.adjustsFontSizeToFitWidth = true;
    _hansFreeButton.titleLabel.adjustsFontSizeToFitWidth = true;
    _captureCamButton.titleLabel.adjustsFontSizeToFitWidth = true;
    _muteButton.titleLabel.adjustsFontSizeToFitWidth = true;
    _switchCamButton.titleLabel.adjustsFontSizeToFitWidth = true;
}

- (void)setupTRTCCloud {
    [self.remoteUidSet removeAllObjects];
    
    [self.trtcCloud startLocalPreview:_isFrontCamera view:self.view];
    
    TRTCParams *params = [TRTCParams new];
    params.sdkAppId = SDKAppID;
    params.roomId = _roomId;
    params.userId = _userId;
    params.role = TRTCRoleAnchor;
    params.userSig = [GenerateTestUserSig genTestUserSig:params.userId];
    
    [self.trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
    
    TRTCVideoEncParam *encParams = [TRTCVideoEncParam new];
    encParams.videoResolution = TRTCVideoResolution_640_360;
    encParams.videoBitrate = 550;
    encParams.videoFps = 15;
    
    [self.trtcCloud setVideoEncoderParam:encParams];
    [self.trtcCloud startLocalAudio:TRTCAudioQualityMusic];
}

- (void)dealloc {
    [self.trtcCloud exitRoom];
    [TRTCCloud destroySharedIntance];
}

#pragma mark - IBActions

- (IBAction)onSwitchCameraClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    _isFrontCamera = !_isFrontCamera;
    [[_trtcCloud getDeviceManager] switchCamera:_isFrontCamera];
}

- (IBAction)onVideoCaptureClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if ([sender isSelected]) {
        [_trtcCloud stopLocalPreview];
    } else {
        [_trtcCloud startLocalPreview:_isFrontCamera view:self.view];
    }
}

- (IBAction)onMicCaptureClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if ([sender isSelected]) {
        [_trtcCloud muteLocalAudio:true];
    } else {
        [_trtcCloud muteLocalAudio:false];
    }
}

- (IBAction)onSwitchSpeakerClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if ([sender isSelected]) {
        [[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteEarpiece];
    } else {
        [[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteSpeakerphone];
    }
}

#pragma mark - TRTCCloud Delegate

- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
    NSInteger index = [self.remoteUidSet indexOfObject:userId];
    if (available) {
        if (index != NSNotFound) { return; }
        [_remoteUidSet addObject:userId];
    } else {
        [_trtcCloud stopRemoteView:userId streamType:TRTCVideoStreamTypeSmall];
        [_remoteUidSet removeObject:userId];
    }
    [self refreshRemoteVideoViews];
}

- (void)refreshRemoteVideoViews {
    NSInteger index = 0;
    for (NSString* userId in _remoteUidSet) {
        if (index >= maxRemoteUserNum) { return; }
        [_remoteViewArr[index] setHidden:false];
        [_trtcCloud startRemoteView:userId streamType:TRTCVideoStreamTypeSmall
                               view:_remoteViewArr[index++]];
    }
}

@end
