//
//  VideoCallingEnterViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/6/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit

/*
 Real-Time Audio Call
 TRTC Audio Call
 This document shows how to integrate the real-time audio call feature.
 1. Provide roomid and userid for subsequent video calls
 Documentation: https://cloud.tencent.com/document/product/647/42046
 */
class VideoCallingEnterViewController:UIViewController {
    
    let userIdTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random() % (999999 - 100000 + 1) + 100000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let roomIdTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = "1356732"
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let inputRoomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.VideoCallingEnter.EnterRoomNumber")
        return label
    }()
    
    let inputUserLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.VideoCallingEnter.EnterUserName")
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.VideoCallingEnter.EnterRoom"), for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        userIdTextField.delegate = self
        roomIdTextField.delegate = self
        view.endEditing(true)
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(userIdTextField)
        view.addSubview(roomIdTextField)
        view.addSubview(inputRoomLabel)
        view.addSubview(inputUserLabel)
        view.addSubview(startButton)
    }
    
    private func activateConstraints() {
        inputUserLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(29)
            make.top.equalTo(100)
            make.left.equalTo(44)
        }
        
        userIdTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.top.equalTo(inputUserLabel.snp.bottom).offset(20)
            make.left.equalTo(inputUserLabel)
        }
        
        inputRoomLabel.snp.makeConstraints { make in
            make.width.equalTo(inputUserLabel.snp.width)
            make.height.equalTo(inputUserLabel.snp.height)
            make.top.equalTo(userIdTextField.snp.bottom).offset(20)
            make.left.equalTo(userIdTextField)
        }
        
        roomIdTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.top.equalTo(inputRoomLabel.snp.bottom).offset(20)
            make.left.equalTo(inputRoomLabel)
        }
        
        startButton.snp.makeConstraints { make in
            make.width.equalTo(205)
            make.height.equalTo(39)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.centerX.equalTo(view)
        }
        
    }
    
    private func bindInteraction() {
        startButton.addTarget(self,action: #selector(clickMuteButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func clickMuteButton(sender: UIButton) {
        let videoCallingVC = VideoCallingViewController()
        videoCallingVC.roomId = Int(roomIdTextField.text ?? "") ?? 0
        videoCallingVC.userId = userIdTextField.text ?? ""
        self.navigationController?.pushViewController(videoCallingVC, animated: true)
    }
    
}

extension VideoCallingEnterViewController:UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !userIdTextField.isExclusiveTouch ||  !roomIdTextField.isExclusiveTouch{
            userIdTextField.resignFirstResponder()
            roomIdTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomIdTextField.resignFirstResponder()
        userIdTextField.resignFirstResponder()
        return true
    }
}
