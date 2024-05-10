//
//  ScreenEntranceViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import CoreMedia

/*
 Screen Recording Live Streaming
 The TRTC app supports screen recording live streaming.
 This document shows how to integrate the screen recording live streaming feature.
 1. audience is the audience,click to enter:ScreenAudienceViewController(Audience example)
 2. anchor is the anchor,click to enter:ScreenAnchorViewController(Anchor example)
 Documentation: https://cloud.tencent.com/document/product/647/45750
 */
class ScreenEntranceViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = Localize("TRTC-API-Example.ScreenEntrance.Title")
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        userIdTextField.delegate = self
        roomIdTextField.delegate = self
        view.endEditing(true)
    }
    
    
    var isAnchorChoose : Bool = true
    var roomId :String? = ""
    var userId :String? = ""
    let inputRoomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.ScreenEntrance.EnterRoomNumber")
        return label
    }()
    
    let inputUserLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.ScreenEntrance.EnterUserName")
        return label
    }()
    
    let roleLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.ScreenEntrance.EnterRole")
        return label
    }()
    
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
    
    let anchorButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.ScreenEntrance.Anchor"), for: .normal)
        button.backgroundColor = .themeTintColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let audienceButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.ScreenEntrance.Audience"), for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let enterRoomButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.VideoCallingEnter.EnterRoom"), for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
}

extension ScreenEntranceViewController {
    
    private func setupDefaultUIConfig() {
        view.addSubview(userIdTextField)
        view.addSubview(roomIdTextField)
        view.addSubview(inputRoomLabel)
        view.addSubview(inputUserLabel)
        view.addSubview(roleLabel)
        view.addSubview(anchorButton)
        view.addSubview(audienceButton)
        view.addSubview(enterRoomButton)
    }
    
    private func activateConstraints() {
        inputUserLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(29)
            make.top.equalTo(100)
            make.left.equalTo(30)
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
        
        roleLabel.snp.makeConstraints { make in
            make.width.equalTo(205)
            make.height.equalTo(39)
            make.top.equalTo(roomIdTextField.snp.bottom).offset(20)
            make.left.equalTo(roomIdTextField)
        }
        
        anchorButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.top.equalTo(roleLabel.snp.bottom).offset(20)
            make.left.equalTo(roleLabel)
        }
        
        audienceButton.snp.makeConstraints { make in
            make.width.equalTo(anchorButton)
            make.height.equalTo(anchorButton)
            make.top.equalTo(anchorButton)
            make.left.equalTo(anchorButton.snp.right).offset(25)
        }
        
        enterRoomButton.snp.makeConstraints { make in
            make.width.equalTo(205)
            make.height.equalTo(39)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.centerX.equalTo(view)
        }
    }
    
    
    private func bindInteraction() {
        anchorButton.addTarget(self,action: #selector(clickAnchorButton(sender:)), for: .touchUpInside)
        audienceButton.addTarget(self,action: #selector(clickAudienceButton(sender:)), for: .touchUpInside)
        enterRoomButton.addTarget(self,action: #selector(clickEnterRoomButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func clickAnchorButton(sender: UIButton) {
        isAnchorChoose = true
        anchorButton.backgroundColor = .themeTintColor
        audienceButton.backgroundColor = .gray
    }
    
    @objc func clickAudienceButton(sender: UIButton) {
        isAnchorChoose = false
        anchorButton.backgroundColor = .gray
        audienceButton.backgroundColor = .themeTintColor
    }
    
    @objc func clickEnterRoomButton(sender: UIButton) {
        if isAnchorChoose {
            if #available(iOS 13.0, *) {
                let  anchroVC = ScreenAnchorViewController.init()
                anchroVC.roomId = UInt32(Int(roomIdTextField.text ?? "") ?? 0)
                anchroVC.userId = userIdTextField.text
                navigationController?.pushViewController(anchroVC, animated: true)
            }
            else {
                showAlertViewController(title: Localize("TRTC-API-Example.ScreenEntrance.versionTips"), message: "")
            }
        } else {
            let audienceVC = ScreenAudienceViewController.init()
            audienceVC.roomId = UInt32(Int(roomIdTextField.text ?? "") ?? 0)
            audienceVC.userId = userIdTextField.text ?? ""
            navigationController?.pushViewController(audienceVC, animated: true)
        }
    }
    
}

extension ScreenEntranceViewController:UITextFieldDelegate {
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
    
    func showAlertViewController(title:String,message:String) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Localize("TRTC-API-Example.AlertViewController.determine"), style: .default)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
}

