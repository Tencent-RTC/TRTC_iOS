//
//  LiveAnchorViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/29.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_TRTC

/*
 Interactive Live Audio Streaming - Listener
 The TRTC app supports interactive live audio streaming.
 This document shows how to integrate the interactive live audio streaming feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .voiceChatRoom)
 2. Enable local audio: trtcCloud.startLocalAudio(.music)
 3. Mute a remote user: trtcCloud.muteRemoteAudio(userId as String, mute: muteButton.isSelected)
 4. Become speaker/listener: trtcCloud.switch(.audience)
 Documentation: https://cloud.tencent.com/document/product/647/45753
 */

class VoiceChatRoomAudienceViewController: UIViewController {
    
    var roomId: UInt32 = 0
    var userId: String = ""
    
    let anchorIdSet: NSMutableOrderedSet = {
        let set = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
        return set
    }()
    
    let trtcCloud: TRTCCloud = {
        return TRTCCloud.sharedInstance()
    }()
    
    let userIdArray: [String] = {
        var array = [String]()
        return array
    }()
    
    let anchorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localize("TRTC-API-Example.VoiceChatRoomAudience.AudienceOperate")
        label.backgroundColor = .clear
        label.textColor = .white
       
        return label
    }()
        
    
    let upMicButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.upMic"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.downMic"), for: .selected)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        return button
    }()
    
    let muteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.mute"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoomAnchor.cancelmute"), for: .selected)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //trtcCloud.delegate = self
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        onEnterRoom()
        
        navigationItem.title = "RoomID:" + "\(roomId)"
        navigationItem.leftBarButtonItem = nil
    }
    
    func onEnterRoom() {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.roomId = roomId
        params.userId = userId as String
        params.role = .audience
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId) as String
        trtcCloud.enterRoom(params, appScene: .voiceChatRoom)
        trtcCloud.delegate = self
    }
    
    @objc func onMuteClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = 0
        for uid in anchorIdSet {
            if index >= maxRemoteUserNum {
                return
            }
            guard let userId = uid as? String else {
                return
            }
            trtcCloud.muteRemoteAudio(userId as String, mute: muteButton.isSelected)
        }
    }
    
    @objc func onUpMicClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            trtcCloud.switch(.anchor)
            trtcCloud.startLocalAudio(.music)
        } else {
            trtcCloud.switch(.audience)
            trtcCloud.stopLocalAudio()
        }
    }
    
    deinit {
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
}

// MARK: - UI Layout
extension VoiceChatRoomAudienceViewController {
    
    //Build view
    private func constructViewHierarchy() {
        view.addSubview(muteButton)
        view.addSubview(upMicButton)
        view.addSubview(anchorLabel)
    }
    
    //view layout
    private func activateConstraints() {
        
        muteButton.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.leading.equalTo(10)
            make.bottom.equalTo(-60)
        }
        
        upMicButton.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.bottom.equalTo(muteButton)
            make.leading.equalTo(120)
        }
        
        anchorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-130)
            make.leading.equalTo(muteButton)
        }
    }
    
    //Binding events
    private func bindInteraction() {
        upMicButton.addTarget(self, action: #selector(onUpMicClick(sender: )), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(onMuteClick(sender: )), for: .touchUpInside)
    }
}

// MARK: - TRTCCloudDelegate
extension VoiceChatRoomAudienceViewController: TRTCCloudDelegate {
    func onUserAudioAvailable(_ userId: String, available: Bool) {
        let index = anchorIdSet.index(of: userId)
        if available {
            if index != NSNotFound {
                return
            }
            anchorIdSet.add(userId)
        } else {
            if index != NSNotFound {
                anchorIdSet.remove(userId)
            }
        }
    }
}
