//
//  LiveAudienceViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/6/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC

/*
 Interactive Live Video Streaming - Audience
 The TRTC app supports interactive live video streaming.
 This document shows how to integrate the interactive live video streaming feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Display the video of a remote user: trtcCloud.startRemoteView(userId, streamType: .big, view: view)
 3. Mute a remote user: trtcCloud.muteRemoteAudio(userId as! String, mute: muteButton.isSelected)
 Documentation: https://cloud.tencent.com/document/product/647/43181
 */
class LiveAudienceViewController:UIViewController {
    
    let trtcCloud = TRTCCloud()
    var roomId: Int = 0
    var userId: String = ""
    
    let audienceLabel :UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.LiveAudience.Operating")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let muteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.LiveAudience.mute"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.LiveAudience.muteoff"), for: .selected)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let anchorUserIdSet:NSMutableOrderedSet = {
        let set = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
        return set
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        onEnterRoom()
    }
    
    func onEnterRoom() {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(roomId)
        params.userId = userId
        params.role = .audience
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        
        trtcCloud.delegate = self
        trtcCloud.enterRoom(params, appScene: .LIVE)
    }
    
    deinit {
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    private func setupDefaultUIConfig(){
        view.addSubview(audienceLabel)
        view.addSubview(muteButton)
    }
    
    //layout
    private func activateConstraints() {
        audienceLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.bottom).offset(-100)
            make.left.equalTo(20)
        }
        
        muteButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.top.equalTo(audienceLabel.snp.bottom).offset(10)
            make.left.equalTo(audienceLabel)
        }
    }
    
    //Bind
    private func bindInteraction() {
        muteButton.addTarget(self, action: #selector(clickmuteButton), for: .touchUpInside)
    }
    
    @objc func clickmuteButton() {
        
        muteButton.isSelected = !muteButton.isSelected
        let  index = 0
        for userId in anchorUserIdSet{
            if index >= maxRemoteUserNum{
                return
            }
            trtcCloud.muteRemoteAudio(userId as! String, mute: muteButton.isSelected)
        }
    }
    
}

extension LiveAudienceViewController : TRTCCloudDelegate {
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        let index = anchorUserIdSet.index(of: userId)
        if available{
            trtcCloud.startRemoteView(userId, streamType: .big, view: view)
            if index != NSNotFound {
                return
            }
            anchorUserIdSet.add(userId)
        }else{
            trtcCloud.stopRemoteView(userId, streamType: .big)
            if (index != 0){
                anchorUserIdSet.remove(userId)
            }
        }
    }
}



