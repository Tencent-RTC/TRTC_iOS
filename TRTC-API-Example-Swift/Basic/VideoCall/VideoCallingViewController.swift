//
//  VideoCallingViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/23.
//  Copyright © 2022 Tencent. All rights reserved.


/*
 实时视频通话功能
 TRTC APP 实时视频通话功能
 本文件展示如何集成实时视频通话功能
 1、切换摄像头 API:[[_trtcCloud getDeviceManager] switchCamera:_isFrontCamera];
 2、打开关闭摄像头 API: [self.trtcCloud startLocalPreview:_isFrontCamera view:_localVideoView];
 [self.trtcCloud stopLocalPreview];
 3、切换听筒与扬声器 API：[[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteEarpiece];
 [[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteSpeakerphone];
 4、静音当前设备，其他人将无法听到该设备的声音 API: [_trtcCloud muteLocalAudio:true];
 参考文档：https://cloud.tencent.com/document/product/647/42044
 */

/*
 Real-Time Audio Call
 TRTC Audio Call
 This document shows how to integrate the real-time audio call feature.
 1. Switch between the speaker and receiver: [[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteSpeakerphone]
 2. Mute the device so that others won’t hear the audio of the device: [_trtcCloud muteLocalAudio:true]
 3. Display other network and volume information: delegate -> onNetworkQuality, onUserVoiceVolume
 Documentation: https://cloud.tencent.com/document/product/647/42046
 */


import Foundation
import UIKit
import TXLiteAVSDK_TRTC
import SnapKit

/// Demo中最大限制进房用户个数为6, 具体可根据需求来定最大进房人数。
let maxRemoteUserNum : Int = 6
class VideoCallingViewController:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        isFrontCamera = true
        trtcCloud.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        setupTRTCCloud()
        view .sendSubviewToBack(view)
    }
    
    private func setupTRTCCloud(){
        remoteUidSet.removeAllObjects()
        trtcCloud.startLocalPreview(isFrontCamera, view: view)
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(roomId)
        params.userId = userId
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        trtcCloud.enterRoom(params, appScene: .videoCall)
        
        let encParams =  TRTCVideoEncParam()
        encParams.videoResolution = ._640_360
        encParams.videoBitrate = 550
        encParams.videoFps = 15
        trtcCloud.setVideoEncoderParam(encParams)
        trtcCloud.startLocalAudio(.music)
    }
    
    private var isFrontCamera = false
    private var roomId : Int = 0
    private var  userId : String = ""
    private var trtcCloud: TRTCCloud = TRTCCloud.sharedInstance()
    
    let videoOptionsLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.VideoCalling.videoOptions")
        return lable
    }()
    
    let switchCamButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.useBehindCam"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.useFrontCam"), for: .selected)
        return button
    }()
    
    let captureCamButton :UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.closeCam"), for: .selected)
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.openCam"), for: .normal)
        return button
    }()
    
    
    let audioOptionsLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        
        lable.textColor = .white
        
        lable.text = Localize("TRTC-API-Example.VideoCalling.audioOptions")
        
        return lable
    }()
    
    let muteButton :UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.mute"), for: .selected)
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.cancelMute"), for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        return button
    }()
    
    let hansFreeButton :UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.speaker"), for: .selected)
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.speaker"), for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        return button
    }()
    
    let remoteUidSet:NSMutableOrderedSet={
        let set = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
        return set
    }()
    
    let remoteViewArr:NSArray={
        let array = NSArray()
        return array
    }()
    
    func initWithRoomId (roomid:Int ,userid:String) -> VideoCallingViewController{
        roomId = roomid
        userId = userid
        return self
    }
    
    
}


extension VideoCallingViewController{
    
    private func setupDefaultUIConfig(){
        view.addSubview(captureCamButton)
        view.addSubview(switchCamButton)
        view.addSubview(muteButton)
        view.addSubview(hansFreeButton)
        view.addSubview(videoOptionsLabel)
        view.addSubview(audioOptionsLabel)
    }
    
    private func activateConstraints(){
        videoOptionsLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(35)
            make.top.equalTo(view.snp.bottom).offset(-200)
            make.left.equalTo(20)
        }
        
        switchCamButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.top.equalTo(videoOptionsLabel).offset(43)
            make.left.equalTo(videoOptionsLabel)
        }
        
        captureCamButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.top.equalTo(videoOptionsLabel).offset(43)
            make.left.equalTo(switchCamButton.snp.right).offset(25)
        }
        
        audioOptionsLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(35)
            make.top.equalTo(switchCamButton.snp.bottom).offset(10)
            make.left.equalTo(switchCamButton)
        }
        
        muteButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.top.equalTo(audioOptionsLabel.snp.bottom).offset(10)
            make.left.equalTo(audioOptionsLabel)
        }
        
        hansFreeButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.top.equalTo(audioOptionsLabel.snp.bottom).offset(10)
            make.left.equalTo(muteButton.snp.right).offset(25)
        }
        
    }
    
    private func bindInteraction(){
            switchCamButton.addTarget(self, action: #selector(clickSwitchCam), for: .touchUpInside)
            captureCamButton.addTarget(self, action: #selector(clickCapTureCam), for: .touchUpInside)
            muteButton.addTarget(self, action: #selector(clickMuteButton), for: .touchUpInside)
            hansFreeButton.addTarget(self, action: #selector(clickHansFreeButton), for: .touchUpInside)
        }
    
}

extension VideoCallingViewController{
    
    @objc private func clickSwitchCam(){
        switchCamButton.isSelected = !switchCamButton.isSelected
        isFrontCamera = !isFrontCamera
        trtcCloud.getDeviceManager().switchCamera(isFrontCamera)
        if switchCamButton.isSelected{
            
        }else{
            trtcCloud.startLocalPreview(isFrontCamera, view: view)
        }
        
    }
    
    @objc private func clickCapTureCam(){
        captureCamButton.isSelected = !captureCamButton.isSelected
        if captureCamButton.isSelected{
            trtcCloud.stopLocalPreview()
        }else{
            trtcCloud.startLocalPreview(isFrontCamera, view: view)
        }
        
    }
    
    @objc private func clickMuteButton(){
        muteButton.isSelected = !muteButton.isSelected
        if muteButton.isSelected{
            trtcCloud.muteLocalAudio(true)
        }else{
            trtcCloud.muteLocalAudio(false)
        }
        
    }
    
    @objc private func clickHansFreeButton(){
        hansFreeButton.isSelected = !hansFreeButton.isSelected
        if hansFreeButton.isSelected{
            trtcCloud.getDeviceManager().setAudioRoute(.earpiece)
        }else{
            trtcCloud.getDeviceManager().setAudioRoute(.speakerphone)
        }
    }
    
    func dealloc(){
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
}

extension VideoCallingViewController:TRTCCloudDelegate{
    func onUserAudioAvailable(_ userId: String, available: Bool) {
        let index = remoteUidSet.index(of: userId)
        if available{
            if index != NSNotFound{
                return
            }
            remoteUidSet.add(userId)
        }
        else{
            trtcCloud.stopRemoteView(userId, streamType: .small)
            remoteUidSet.remove(userId)
        }
        refreshRemoteVideoViews()
        
    }
    
    func refreshRemoteVideoViews(){
        var index = 0
        if remoteUidSet.count == 0{
            return
        }
        for userId in remoteUidSet{
            if index >= maxRemoteUserNum{
                return
            }
            UIView(frame: remoteViewArr[index] as! CGRect).isHidden = false
            trtcCloud.startRemoteView(userId as! String, streamType:.small, view:  UIView(coder: remoteViewArr[index] as! NSCoder))
            index = index + 1
        }
    }
}
