//
//  LiveEnterViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/29.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import SnapKit

/*
 语音互动直播功能
 TRTC APP 支持语音互动直播功能
 本文件展示如何集成语音互动直播功能
 1、audience为观众，点击进入VoiceChatRoomAudienceViewController(观众端示例)
 2、anchor为主播，点击进入VoiceChatRoomAnchorViewController（主播端示例）
 参考文档：https://cloud.tencent.com/document/product/647/45753
 */

/*
 Interactive Live Audio Streaming - Room Owner
 The TRTC app supports interactive live audio streaming.
 This document shows how to integrate the interactive live audio streaming feature.
 1. audience is the audience,click to enter:VoiceChatRoomAudienceViewController(Audience example)
 2. anchor is the anchor,click to enter:VoiceChatRoomAnchorViewController(Anchor example)
 Documentation: https://cloud.tencent.com/document/product/647/45753
 */

enum UserType: String {
    case anchor
    case audience
}

class VoiceChatRoomEnterViewController: UIViewController {

    lazy var userType: UserType = {
        var userType = UserType.anchor
        return userType
    }()
    
    let userIdentifyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.VoiceChatRoom.ChooseUserIdentify")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let userIdTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .white
        textField.text = "324532"
        return textField
    }()
    
    let roomIdTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .white
        textField.text = "1256732"
        return textField
    }()
    
    let inputRoomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.VoiceChatRoom.EnterRoomNumber")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let inputUserLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.VoiceChatRoom.EnterUserName")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoom.EnterRoom"), for: UIControl.State.normal)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let anchorButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoom.Anchor"), for: UIControl.State.normal)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        return button
    }()
    
    let audienceButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(Localize("TRTC-API-Example.VoiceChatRoom.Audience"), for: UIControl.State.normal)
        button.backgroundColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        navigationItem.title = Localize("TRTC-API-Example.VoiceChatRoom.Title")
        navigationItem.leftBarButtonItem = nil
    }
    
    func setUserType(userType: UserType) {
        self.userType = userType
        switch userType {
        case .anchor:
            audienceButton.backgroundColor = .gray
            anchorButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        case .audience:
            audienceButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
            anchorButton.backgroundColor = .gray
        }
    }
    
    @objc func OnStartClick(sender: UIButton) {
        switch userType {
            case .anchor:
                let voiceChatRoomAnchorViewController = VoiceChatRoomAnchorViewController()
                guard let roomIdText = roomIdTextField.text else {
                    return
                }
                guard let roomId = UInt32(roomIdText) else {
                    return
                }
                voiceChatRoomAnchorViewController.roomId = roomId
                guard let userId = userIdTextField.text, !userId.isEmpty else {
                    return
                }
                voiceChatRoomAnchorViewController.userId = userId
                navigationController?.pushViewController(voiceChatRoomAnchorViewController, animated: true)
            
            case .audience:
                let voiceChatRoomAnchorViewController = VoiceChatRoomAudienceViewController()
                guard let roomIdText = roomIdTextField.text else {
                    return
                }
                guard let roomId = UInt32(roomIdText) else {
                    return
                }
                voiceChatRoomAnchorViewController.roomId = roomId
                guard let userId = userIdTextField.text, !userId.isEmpty else {
                    return
                }
                voiceChatRoomAnchorViewController.userId = userId
                navigationController?.pushViewController(voiceChatRoomAnchorViewController, animated: true)
        }
        
    }
       
    
    @objc func onAudienceClick(sender: UIButton) {
        setUserType(userType: UserType.audience)
    }
    
    @objc func onAnchorClick(sender: UIButton) {
        setUserType(userType: UserType.anchor)
    }
    
}

//MARK: - UI Layout
extension VoiceChatRoomEnterViewController {
    
    // 构建视图
    private func constructViewHierarchy() {
        view.addSubview(inputRoomLabel)
        view.addSubview(roomIdTextField)
        view.addSubview(inputUserLabel)
        view.addSubview(userIdTextField)
        view.addSubview(startButton)
        view.addSubview(anchorButton)
        view.addSubview(audienceButton)
        view.addSubview(userIdentifyLabel)
    }
    
    // 视图布局
    private func activateConstraints() {
        
        userIdTextField.snp.makeConstraints { make in
            make.top.equalTo(280)
            make.leading.equalTo(50)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        inputUserLabel.snp.makeConstraints { make in
            make.top.equalTo(250)
            make.leading.equalTo(50)
        }
        startButton.snp.makeConstraints { make in
            make.leading.equalTo(50)
            make.bottom.equalTo(-150)
            make.width.equalTo(300)
        }
        
        inputRoomLabel.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.leading.equalTo(50)
        }
        
        roomIdTextField.snp.makeConstraints { make in
            make.top.equalTo(180)
            make.leading.equalTo(50)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        userIdentifyLabel.snp.makeConstraints { make in
            make.top.equalTo(330)
            make.leading.equalTo(userIdTextField)
        }
        
        anchorButton.snp.makeConstraints { make in
            make.top.equalTo(360)
            make.leading.equalTo(userIdTextField)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        audienceButton.snp.makeConstraints { make in
            make.leading.equalTo(userIdTextField)
            make.leading.equalTo(135)
            make.top.equalTo(360)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
    }
    
    // 绑定事件 / 回调
    private func bindInteraction() {
        startButton.addTarget(self, action: #selector(OnStartClick(sender: )), for: .touchUpInside)
        anchorButton.addTarget(self, action: #selector(onAnchorClick(sender: )), for: .touchUpInside)
        audienceButton.addTarget(self, action: #selector(onAudienceClick(sender: )), for: .touchUpInside)
    }
    
}


