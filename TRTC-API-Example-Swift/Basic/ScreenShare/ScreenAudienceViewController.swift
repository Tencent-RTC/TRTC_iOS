//
//  ScreenAudienceViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC

/*
 Screen Recording Live Streaming
 The TRTC app supports screen recording live streaming.
 This document shows how to integrate the screen recording live streaming feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Display the video of a remote user: trtcCloud.startRemoteView(userId, streamType: .big, view: view)
 Documentation: https://cloud.tencent.com/document/product/647/45750
 */
class ScreenAudienceViewController : UIViewController,TRTCCloudDelegate {
    
    var roomId : UInt32 = 0
    var userId : String = ""
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let remoteView:UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = Localize("TRTC-API-Example.ScreenAudience.Title").appending(String(roomId))
        view.addSubview(remoteView)
        trtcCloud.delegate = self
        setupTRTCCloud()
        activateConstraints()
    }
    
    private func setupTRTCCloud() {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.strRoomId = String(roomId)
        params.userId = userId
        params.role = .audience
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        
        trtcCloud.startLocalAudio(.music)
        trtcCloud.enterRoom(params, appScene: .videoCall)
    }
    
    func activateConstraints() {
        remoteView.snp.makeConstraints { make in
            make.top.left.right.width.equalTo(view)
        }
    }
    
    func onUserAudioAvailable(_ userId: String, available: Bool) {
        if available{
            remoteView.isHidden = false
            trtcCloud.startRemoteView(userId, streamType: .big, view: remoteView)
        }else{
            remoteView.isHidden = true
        }
    }
    
    deinit {
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
}
