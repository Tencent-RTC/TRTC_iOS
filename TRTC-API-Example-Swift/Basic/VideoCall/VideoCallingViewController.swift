//
//  VideoCallingViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/6/23.
//  Copyright © 2022 Tencent. All rights reserved.

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
import SnapKit
/*
 Real-Time Audio Call
 TRTC Audio Call
 This document shows how to integrate the real-time audio call feature.
 1. Switch between the speaker and receiver: trtcCloud.getDeviceManager().switchCamera(isFrontCamera)
 2. Turn the camera on and off: trtcCloud.startLocalPreview(isFrontCamera, view: view)
 self.trtcCloud.stopLocalPreview()
 3. Switch between handset and speaker API: trtcCloud.getDeviceManager().setAudioRoute(.earpiece)
 trtcCloud.getDeviceManager().setAudioRoute(.speakerphone)
 4. Mute the current device so others will not be able to hear it API:trtcCloud.muteLocalAudio(true)
 5. Set the key code of TRTC : setupTRTCCloud()
 Documentation: https://cloud.tencent.com/document/product/647/42046
 */
/// In the demo, the maximum number of users who can enter the room is
// 6. The maximum number of users who can enter the room can be determined according to the needs.
let maxRemoteUserNum : Int = 6
class VideoCallingViewController:UIViewController {
    
    private var isFrontCamera = false
    private let trtcCloud: TRTCCloud = TRTCCloud.sharedInstance()
    var roomId : Int = 0
    var userId : String = ""
    var remoteViewArr: [UIView] = []
    
    let videoOptionsLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.VideoCalling.videoOptions")
        return lable
    }()
    
    let switchCamButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.useBehindCam"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.useFrontCam"), for: .selected)
        return button
    }()
    
    let captureCamButton :UIButton = {
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
    
    let muteButton :UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.mute"), for: .selected)
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.cancelMute"), for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        return button
    }()
    
    let hansFreeButton :UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.speaker"), for: .selected)
        button.setTitle(Localize("TRTC-API-Example.VideoCalling.speaker"), for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        return button
    }()
    
    let remoteUidSet:NSMutableOrderedSet = {
        let set = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
        return set
    }()
    
    let leftRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    let leftRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    let leftRemoteViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    let rightRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    let rightRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    let rightRemoteViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        isFrontCamera = true
        trtcCloud.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        setupTRTCCloud()
        remoteViewArr = [leftRemoteViewA,rightRemoteViewA,leftRemoteViewC,leftRemoteViewB,rightRemoteViewB,leftRemoteViewC]
        view .sendSubviewToBack(view)
    }
    
    deinit {
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
    }
    
    private func setupTRTCCloud() {
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
    
    private func setupDefaultUIConfig() {
        view.addSubview(captureCamButton)
        view.addSubview(switchCamButton)
        view.addSubview(muteButton)
        view.addSubview(hansFreeButton)
        view.addSubview(videoOptionsLabel)
        view.addSubview(audioOptionsLabel)
        view.addSubview(leftRemoteViewA)
        view.addSubview(leftRemoteViewB)
        view.addSubview(leftRemoteViewC)
        view.addSubview(rightRemoteViewA)
        view.addSubview(rightRemoteViewB)
        view.addSubview(rightRemoteViewC)
    }
    
    private func activateConstraints() {
        leftRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-56)/2)
            make.height.equalTo(172)
            make.left.equalTo(20)
            make.top.equalTo(100)
        }
        rightRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.left.equalTo(leftRemoteViewA.snp.right).offset(50)
            make.top.equalTo(leftRemoteViewA)
        }
        
        leftRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.top.equalTo(leftRemoteViewA.snp.bottom).offset(5)
            make.left.equalTo(leftRemoteViewA)
        }
        
        rightRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteViewB)
            make.top.equalTo(leftRemoteViewB)
            make.left.equalTo(leftRemoteViewB.snp.right).offset(50)
        }
        
        
        leftRemoteViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteViewB)
            make.top.equalTo(leftRemoteViewB.snp.bottom).offset(5)
            make.left.equalTo(leftRemoteViewB)
        }
        rightRemoteViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewC)
            make.height.equalTo(leftRemoteViewC)
            make.top.equalTo(leftRemoteViewC)
            make.left.equalTo(leftRemoteViewC.snp.right).offset(50)
        }
        
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
    
    private func bindInteraction() {
        switchCamButton.addTarget(self,action: #selector(clickSwitchCam(sender:)), for: .touchUpInside)
        captureCamButton.addTarget(self,action: #selector(clickCapTureCam(sender:)), for: .touchUpInside)
        muteButton.addTarget(self,action: #selector(clickMuteButton(sender:)), for: .touchUpInside)
        hansFreeButton.addTarget(self,action: #selector(clickHansFreeButton(sender:)), for: .touchUpInside)
        }
    
    @objc private func clickSwitchCam(sender: UIButton) {
        switchCamButton.isSelected = !switchCamButton.isSelected
        isFrontCamera = !isFrontCamera
        trtcCloud.getDeviceManager().switchCamera(isFrontCamera)
    }
    
    @objc private func clickCapTureCam(sender: UIButton) {
        captureCamButton.isSelected = !captureCamButton.isSelected
        if captureCamButton.isSelected {
            trtcCloud.stopLocalPreview()
        }else{
            trtcCloud.startLocalPreview(isFrontCamera, view: view)
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
    
    @objc private func clickHansFreeButton(sender: UIButton) {
        hansFreeButton.isSelected = !hansFreeButton.isSelected
        if hansFreeButton.isSelected {
            trtcCloud.getDeviceManager().setAudioRoute(.earpiece)
        }else {
            trtcCloud.getDeviceManager().setAudioRoute(.speakerphone)
        }
    }
}

extension VideoCallingViewController:TRTCCloudDelegate {
    func onUserAudioAvailable(_ userId: String, available: Bool) {
        let index = remoteUidSet.index(of: userId)
        if available {
            if index != NSNotFound{
                return
            }
            remoteUidSet.add(userId)
        }
        else {
            trtcCloud.stopRemoteView(userId, streamType: .small)
            remoteUidSet.remove(userId)
        }
        refreshRemoteVideoViews()
    }
    
    func refreshRemoteVideoViews() {
        var index = 0
        if remoteUidSet.count == 0 {
            return
        }
        for userId in remoteUidSet {
            if index >= maxRemoteUserNum {
                return
            }
            remoteViewArr[index].isHidden = false
            guard let userID = userId as? String else {
                continue
            }
            trtcCloud.startRemoteView(userID, streamType:.small, view: remoteViewArr[index])
            index = index + 1
        }
    }
}
