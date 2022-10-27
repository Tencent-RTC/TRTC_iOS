//
//  LiveAnchorViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/30.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC

/*
 视频互动直播功能 - 主播端示例
 TRTC APP 支持视频互动直播功能
 本文件展示如何集成视频互动直播功能
 1、进入TRTC房间。 API:trtcCloud.enterRoom(params, appScene: .LIVE)
 2、开启本地视频预览。  API:trtcCloud.startLocalPreview(true, view: view)
 3、切换摄像头：API:trtcCloud.getDeviceManager().switchCamera(!changeCameraButton.isSelected)
 4、本地静音：API:trtcCloud.muteLocalAudio(muteButton.isSelected)
 5、TRTC关键推流代码：API：startPushStream()
 参考文档：https://cloud.tencent.com/document/product/647/43181
 */

/*
 Interactive Live Video Streaming - Anchor
 The TRTC app supports interactive live video streaming.
 This document shows how to integrate the interactive live video streaming feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Enable local video preview: trtcCloud.startLocalPreview(true, view: view)
 3. Switch camera: trtcCloud.getDeviceManager().switchCamera(!changeCameraButton.isSelected)
 4. Mute local audio: trtcCloud.muteLocalAudio(muteButton.isSelected)
 5. TRTC key streaming code: startPushStream()
 Documentation: https://cloud.tencent.com/document/product/647/43181
 */
class LiveAnchorViewController:UIViewController, TRTCCloudDelegate {
    
    let trtcCloud = TRTCCloud()
    var roomId: Int = 0
    var userId: String = ""
    
    let videoOperatingLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.LiveAnchor.VideoOptions")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let changeCameraButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.LiveAnchor.rearcamera"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.LiveAnchor.frontcamera"), for: .selected)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let openCameraButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.LiveAnchor.closecamera"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.LiveAnchor.opencamera"), for: .selected)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let muteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.LiveAnchor.mute"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.LiveAnchor.cancelmute"), for: .selected)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let audioOperatingLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.LiveAnchor.AudioOptions")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        startPushStream()
    }
    
    func startPushStream() {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(roomId)
        params.userId = userId
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        
        trtcCloud.delegate = self
        trtcCloud.enterRoom(params, appScene: .LIVE)
        trtcCloud.startLocalPreview(true, view: view)
        trtcCloud.startLocalAudio(.music)
        
        let videoEncParam = TRTCVideoEncParam()
        videoEncParam.videoFps = 24
        videoEncParam.resMode = .portrait
        videoEncParam.videoResolution = ._960_540
        trtcCloud.setVideoEncoderParam(videoEncParam)
    }
    
    private func setupDefaultUIConfig(){
        view.addSubview(videoOperatingLabel)
        view.addSubview(changeCameraButton)
        view.addSubview(openCameraButton)
        view.addSubview(muteButton)
        view.addSubview(audioOperatingLabel)
    }
    
    //布局
    private func activateConstraints() {
        videoOperatingLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.bottom).offset(-180)
            make.left.equalTo(20)
        }
        
        changeCameraButton.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(30)
            make.top.equalTo(videoOperatingLabel.snp.bottom).offset(10)
            make.left.equalTo(videoOperatingLabel)
        }
        
        openCameraButton.snp.makeConstraints { make in
            make.width.equalTo(changeCameraButton)
            make.height.equalTo(changeCameraButton)
            make.top.equalTo(changeCameraButton)
            make.left.equalTo(changeCameraButton.snp.right).offset(10)
        }
        audioOperatingLabel.snp.makeConstraints { make in
            make.width.equalTo(videoOperatingLabel)
            make.height.equalTo(videoOperatingLabel)
            make.top.equalTo(changeCameraButton.snp.bottom).offset(10)
            make.left.equalTo(videoOperatingLabel)
        }
        
        muteButton.snp.makeConstraints { make in
            make.width.equalTo(openCameraButton)
            make.height.equalTo(openCameraButton)
            make.top.equalTo(audioOperatingLabel.snp.bottom).offset(10)
            make.left.equalTo(audioOperatingLabel)
        }
    }
    
    //绑定
    private func bindInteraction() {
        changeCameraButton.addTarget(self, action: #selector(clickChangeCameraButton), for: .touchUpInside)
        openCameraButton.addTarget(self, action: #selector(clickOpenCameraButton), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(clickMuteButton), for: .touchUpInside)
    }
    
    @objc func clickChangeCameraButton() {
        changeCameraButton.isSelected = !changeCameraButton.isSelected
        trtcCloud.getDeviceManager().switchCamera(!changeCameraButton.isSelected)
    }
    
    @objc func clickOpenCameraButton() {
        openCameraButton.isSelected = !openCameraButton.isSelected
        if openCameraButton.isSelected{
            trtcCloud.stopLocalPreview()
        }else{
            trtcCloud.startLocalPreview(true, view: view)
        }
    }
    
    @objc func clickMuteButton() {
        muteButton.isSelected = !muteButton.isSelected
        trtcCloud.muteLocalAudio(muteButton.isSelected)
    }
    
    deinit {
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
}



