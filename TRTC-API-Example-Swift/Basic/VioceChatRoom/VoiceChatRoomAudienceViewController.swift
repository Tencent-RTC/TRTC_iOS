//
//  VoiceChatRoomAudienceViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC

class VoiceChatRoomAudienceViewController:UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        
    }
    
    func initWithRoomId (roomId:Int ,userId:String) -> VoiceChatRoomAudienceViewController{
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(roomId)
        params.userId = userId
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        
        trtcCloud.delegate = self
        trtcCloud.enterRoom(params, appScene: .voiceChatRoom)
        return self
    }
    
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let anchorIdSet:NSMutableOrderedSet={
        let set = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
        return set
    }()
    
    let audienceLabel :UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.VoiceChatRoomAudience.AudienceOperate")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let muteButton: UIButton={
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.mute"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.cancelmute"), for: .selected)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let upMicButton: UIButton={
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.upMic"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.downMic"), for: .selected)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
}

extension VoiceChatRoomAudienceViewController{
    
    
    private func setupDefaultUIConfig(){
        view.addSubview(audienceLabel)
        view.addSubview(muteButton)
        view.addSubview(upMicButton)
    }
    
    private func bindInteraction(){
        muteButton.addTarget(self, action: #selector(clickMuteButton), for: .touchUpInside)
        upMicButton.addTarget(self, action: #selector(clickUpMicButton), for: .touchUpInside)
    }
    
    private func activateConstraints(){
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
        
        upMicButton.snp.makeConstraints { make in
            make.width.equalTo(muteButton)
            make.height.equalTo(muteButton)
            make.top.equalTo(muteButton)
            make.left.equalTo(muteButton.snp.right).offset(25)
        }
    }
    
    @objc func clickMuteButton(){
        muteButton.isSelected = !muteButton.isSelected
        let index = 0
        for userId in anchorIdSet{
            if index >= maxRemoteUserNum{
                return
            }
            trtcCloud.muteRemoteAudio(userId as! String, mute: muteButton.isSelected)
        }
    }
    
    @objc func clickUpMicButton(){
        upMicButton.isSelected = !upMicButton.isSelected
        if upMicButton.isSelected{
            trtcCloud.switch(.anchor)
            trtcCloud.startLocalAudio(.music)
            
        }else{
            trtcCloud.switch(.audience)
            trtcCloud.stopLocalAudio()
        }
    }
    
    func dealloc(){
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    
}

extension VoiceChatRoomAudienceViewController:TRTCCloudDelegate{
    func onUserAudioAvailable(_ userId: String, available: Bool) {
        let index = anchorIdSet.index(of: userId)
        if available{
            if index != NSNotFound{
                return
            }
            anchorIdSet.add(userId)
        }else{
            if (index != 0){
                anchorIdSet.remove(userId)
            }
        }
    }
}

