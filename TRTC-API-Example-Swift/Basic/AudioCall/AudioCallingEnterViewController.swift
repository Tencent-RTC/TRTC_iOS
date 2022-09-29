//
//  AudioCallingEnterViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import SnapKit

/*
 实时语音通话功能
 TRTC APP 实时语音通话功能
 本文件展示如何集成实时语音通话功能
 为之后的语音通话提供roomId和userId
 参考文档：https://cloud.tencent.com/document/product/647/42046
 */

/*
 Real-Time Audio Call
 TRTC Audio Call
 This document shows how to integrate the real-time audio call feature.
 1. Provide roomid and userid for subsequent audio calls
 Documentation: https://cloud.tencent.com/document/product/647/42046
 */

class AudioCallingEnterViewController: UIViewController {
    
    let userIdTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .white
        textField.text = String(arc4random() % (9999999 - 1000000 + 1) + 1000000)
        return textField
    }()
    
    let roomIdTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .white
        textField.text = String(arc4random() % (999999 - 100000 + 1) + 100000)
        return textField
    }()
    
    let inputRoomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.AudioCallingEnter.EnterRoomNumber")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let inputUserLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.AudioCallingEnter.EnterUserName")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        button.setTitle(Localize("TRTC-API-Example.AudioCallingEnter.EnterRoom"), for: UIControl.State.normal)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()

        navigationItem.title = Localize("TRTC-API-Example.AudioCallingEnter.Title")
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func OnStartClick(sender: UIButton) {
        let audioCallingViewController = AudioCallingViewController()
        guard let roomIdText = roomIdTextField.text else {
            return
        }
        guard let roomId = UInt32(roomIdText) else {
            return
        }
        audioCallingViewController.roomId = roomId
        guard let userId = userIdTextField.text, !userId.isEmpty else {
            return
        }
        audioCallingViewController.userId = userId
        navigationController?.pushViewController(audioCallingViewController, animated: true)
    }
    
}

//MARK: - UI Layout
extension AudioCallingEnterViewController {
    
    // 构建视图
    private func constructViewHierarchy() {
        view.addSubview(inputRoomLabel)
        view.addSubview(roomIdTextField)
        view.addSubview(inputUserLabel)
        view.addSubview(userIdTextField)
        view.addSubview(startButton)
    }
    
    // 视图布局
    private func activateConstraints() {
        userIdTextField.snp.makeConstraints { make in
            make.top.equalTo(280)
            make.leading.equalTo(50)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        inputUserLabel.snp.makeConstraints{ make in
            make.top.equalTo(250)
            make.leading.equalTo(50)
        }
        startButton.snp.makeConstraints{ make in
            make.leading.equalTo(50)
            make.bottom.equalTo(-150)
            make.width.equalTo(300)
        }
        
        inputRoomLabel.snp.makeConstraints{ make in
            make.top.equalTo(150)
            make.leading.equalTo(50)
        
        }
        
        roomIdTextField.snp.makeConstraints{ make in
            make.top.equalTo(180)
            make.leading.equalTo(50)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
    }
    
    // 绑定事件 / 回调
    private func bindInteraction() {
        startButton.addTarget(self, action: #selector(OnStartClick(sender: )), for: .touchUpInside)
    }
    
}


