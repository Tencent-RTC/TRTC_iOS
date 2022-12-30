//
//  ScreenAnchorViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC

enum ScreenStatus {
    case screenStart
    case screenWait
    case screenStop
}
/*
 录屏直播功能
 TRTC APP 录屏直播功能
 本文件展示如何集成录屏直播功能
 1、开始屏幕分享 API:   trtcCloud.startScreenCapture(byReplaykit: .big, encParam: encParams, appGroup: "group.com.tencent.liteav.RPLiveStreamShare")
 2、静音 API: trtcCloud.muteLocalAudio(true)
 3、TRTC关键推流代码：API：setupTRTCCloud()
 参考文档：https://cloud.tencent.com/document/product/647/45750
 */

/*
 Screen Recording Live Streaming
 The TRTC app supports screen recording live streaming.
 This document shows how to integrate the screen recording live streaming feature.
 1. Start screen sharing: trtcCloud.startScreenCapture(byReplaykit: .big, encParam: encParams, appGroup: "group.com.tencent.liteav.RPLiveStreamShare")
 2. Mute: trtcCloud.muteLocalAudio(true)
 3. TRTC key streaming code: setupTRTCCloud()
 Documentation: https://cloud.tencent.com/document/product/647/45750
 */
class ScreenAnchorViewController:UIViewController {
    var roomId :UInt32 = 0
    var userId:String? = ""
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let encParams:TRTCVideoEncParam = {
        let encParams = TRTCVideoEncParam()
        return encParams
    }()
    
    var status:ScreenStatus = {
        var status = ScreenStatus.screenStop
        return status
    }()
    
    let roomIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.ScreenAnchor.RoomNumber")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let userIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.ScreenAnchor.UserName")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let resolutionLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.ScreenAnchor.Resolution")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let tipLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.ScreenAnchor.Description")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let startScreenButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.ScreenAnchor.WaitScreenShare"), for: .normal)
        return button
    }()
    
    let muteButton :UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.ScreenAnchor.cancelMute"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.ScreenAnchor.mute"), for: .selected)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        status = ScreenStatus.screenStop
        trtcCloud.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        setupTRTCCloud()
    }
    
    deinit {
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    private func setupTRTCCloud() {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = roomId
        params.userId = userId ?? ""
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId ?? "") as String
        
        encParams.videoResolution = ._1280_720
        encParams.videoBitrate = 500
        encParams.videoFps = 10
        
        trtcCloud.startLocalAudio(.music)
        trtcCloud.startScreenCapture(byReplaykit: .big, encParam: encParams, appGroup: "group.com.tencent.liteav.RPLiveStreamShare")
        trtcCloud.enterRoom(params, appScene: .videoCall)
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(roomIdLabel)
        view.addSubview(userIdLabel)
        view.addSubview(resolutionLabel)
        view.addSubview(tipLabel)
        view.addSubview(startScreenButton)
        view.addSubview(muteButton)
    }
    
    private func activateConstraints() {
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(30)
            make.top.equalTo(90)
            make.left.equalTo(53)
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(roomIdLabel)
            make.top.equalTo(roomIdLabel.snp.bottom).offset(5)
            make.left.equalTo(roomIdLabel)
        }
        
        resolutionLabel.snp.makeConstraints { make in
            make.width.equalTo(userIdLabel)
            make.height.equalTo(userIdLabel)
            make.top.equalTo(userIdLabel.snp.bottom).offset(5)
            make.left.equalTo(userIdLabel)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.width.equalTo(resolutionLabel)
            make.height.equalTo(resolutionLabel)
            make.top.equalTo(resolutionLabel.snp.bottom).offset(5)
            make.left.equalTo(resolutionLabel)
        }
        
        startScreenButton.snp.makeConstraints { make in
            make.width.equalTo(205)
            make.height.equalTo(39)
            make.top.equalTo(404)
            make.centerX.equalTo(self.view)
        }
        
        muteButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.bottom.equalTo(view).offset(-50)
            make.centerX.equalTo(view)
        }
        
    }
    
    private func bindInteraction() {
        startScreenButton.addTarget(self,action: #selector(clickStartScreenButton(sender:)), for: .touchUpInside)
        muteButton.addTarget(self,action: #selector(clickMuteButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func clickStartScreenButton(sender: UIButton) {
        switch status {
        case .screenStart:
            trtcCloud.stopScreenCapture()
            break
        case .screenWait:
            trtcCloud.startScreenCapture(byReplaykit: .big, encParam: encParams, appGroup: "group.com.tencent.liteav.RPLiveStreamShare")
            TRTCBroadcastExtensionLauncher.launch()
            startScreenButton.setTitle(Localize("TRTC-API-Example.ScreenAnchor.WaitScreenShare"), for: .normal)
            break
        case .screenStop:
            TRTCBroadcastExtensionLauncher.launch()
            break
        }
        
    }
    
    @objc private func clickMuteButton(sender: UIButton) {
        muteButton.isSelected = !muteButton.isSelected
        if muteButton.isSelected {
            trtcCloud.muteLocalAudio(true)
        }else{
            trtcCloud.muteLocalAudio(false)
        }
        
    }
    
}

extension ScreenAnchorViewController:TRTCCloudDelegate {
    
    func onScreenCaptureStarted() {
        status = ScreenStatus.screenStart
        startScreenButton.setTitle(Localize("TRTC-API-Example.ScreenAnchor.StopScreenShare"), for: .normal)
    }
    
    func onScreenCaptureStoped(_ reason: Int32) {
        status = ScreenStatus.screenStop
        startScreenButton.setTitle(Localize("TRTC-API-Example.ScreenAnchor.BeginScreenShare"), for: .normal)
    }
    
}
