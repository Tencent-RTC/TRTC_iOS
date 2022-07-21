//
//  VoiceChatRoomAnchorViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC

class VoiceChatRoomAnchorViewController:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        
    }
    
    
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let anchorIdSet:NSMutableOrderedSet={
        let set = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
        return set
    }()
    
    let anchorLabel :UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.VoiceChatRoomAnchor.AnchorOperate")
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
    
    let downMicButton: UIButton={
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.downMic"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.upMic"), for: .selected)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    
    func initWithRoomId (roomId:Int ,userId:String) -> VoiceChatRoomAnchorViewController{
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(roomId)
        params.userId = userId
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        
        trtcCloud.delegate = self
        trtcCloud.enterRoom(params, appScene: .voiceChatRoom)
        trtcCloud.startLocalAudio(.music)
        return self
    }
}

extension VoiceChatRoomAnchorViewController{
    
    
    private func setupDefaultUIConfig(){
        view.addSubview(anchorLabel)
        view.addSubview(muteButton)
        view.addSubview(downMicButton)
    }
    
    
    private func activateConstraints(){
        anchorLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.bottom).offset(-100)
            make.left.equalTo(20)
        }
        
        muteButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.top.equalTo(anchorLabel.snp.bottom).offset(10)
            make.left.equalTo(anchorLabel)
        }
        
        downMicButton.snp.makeConstraints { make in
            make.width.equalTo(muteButton)
            make.height.equalTo(muteButton)
            make.top.equalTo(muteButton)
            make.left.equalTo(muteButton.snp.right).offset(25)
        }
    }
    
    private func bindInteraction(){
        muteButton.addTarget(self, action: #selector(clickMuteButton), for: .touchUpInside)
        downMicButton.addTarget(self, action: #selector(clickDownMicButton), for: .touchUpInside)
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
    
    @objc func clickDownMicButton(){
        downMicButton.isSelected = !downMicButton.isSelected
        if downMicButton.isSelected{
            trtcCloud.switch(.audience)
            trtcCloud.stopLocalAudio()
        }else{
            trtcCloud.switch(.anchor)
            trtcCloud.startLocalAudio(.music)
        }
    }
    
    func dealloc(){
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    
}

extension VoiceChatRoomAnchorViewController:TRTCCloudDelegate{
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

