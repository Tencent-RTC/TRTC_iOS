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

class ScreenAudienceViewController : UIViewController,TRTCCloudDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = Localize("TRTC-API-Example.ScreenAudience.Title").appending(String(roomId))
        view.addSubview(remoteView)
        trtcCloud.delegate = self
        setupTRTCCloud()
        activateConstraints()
    }
    
    
    private func setupTRTCCloud(){
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(roomId)
        params.userId = userId
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        
        trtcCloud.startLocalAudio(.music)
        trtcCloud.enterRoom(params, appScene: .videoCall)
    }
    
    
    var roomId : UInt32 = 0
    var userId : String = ""
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let remoteView:UIView={
        let view = UIView(frame: .zero)
        return view
    }()
    
    func activateConstraints(){
        remoteView.snp.makeConstraints { make in
            make.top.left.right.width.equalTo(view)
        }
    }
    func dealloc(){
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    func onUserAudioAvailable(_ userId: String, available: Bool) {
        if available{
            remoteView.isHidden = false
            trtcCloud.startRemoteView(userId, streamType: .big, view: remoteView)
        }else{
            remoteView.isHidden = true
        }
    }
}
