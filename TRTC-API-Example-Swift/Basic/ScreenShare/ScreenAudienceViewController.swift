//
//  ScreenAudienceViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
/*
 录屏直播功能
 TRTC APP 录屏直播功能
 本文件展示如何集成录屏直播功能
 1、进入TRTC房间。 API:trtcCloud.enterRoom(params, appScene: .LIVE)
 2、开启远程用户直播。API:trtcCloud.startRemoteView(userId, streamType: .big, view: view)
 参考文档：https://cloud.tencent.com/document/product/647/45750
 */

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
        params.roomId = UInt32(roomId)
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
