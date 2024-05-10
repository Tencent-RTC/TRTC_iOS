//
//  StringRoomIdViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/6/30.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC

/*
 String-type Room ID
 The TRTC app supports string-type room IDs.
 This document shows how to enable string-type room IDs in your project.
 1. Set a string-type room ID: params.strRoomId = roomIDTextField.text
 2. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 3. Set the key code of TRTC : startPushStream()
 Documentation: https://cloud.tencent.com/document/product/647/32258
 */
class StringRoomIdViewController : UIViewController, TRTCCloudDelegate {
    
    let bottomConstraint = NSLayoutConstraint()
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let roomIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.StringRoomId.roomId")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let userIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.StringRoomId.userId")
        return lable
    }()
    
    let roomIDTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = "1356732"
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let userIDTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let startPushButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle(Localize("TRTC-API-Example.StringRoomId.start"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.StringRoomId.stop"), for: .selected)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        trtcCloud.delegate = self
        roomIDTextField.delegate = self
        userIDTextField.delegate = self
        title = Localize("TRTC-API-Example.StringRoomId.Title")
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        addKeyboardObserver()
    }
    
    deinit {
        removeKeyboardObserver()
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        trtcCloud.stopLocalRecording()
        TRTCCloud.destroySharedIntance()
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(roomIdLabel)
        view.addSubview(userIdLabel)
        view.addSubview(startPushButton)
        view.addSubview(roomIDTextField)
        view.addSubview(userIDTextField)
    }
    
    private func activateConstraints() {
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(30)
            make.left.equalTo(20)
            make.top.equalTo(view.snp.bottom).offset(-150)
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(roomIdLabel)
            make.left.equalTo(roomIdLabel.snp.right).offset(10)
            make.top.equalTo(roomIdLabel)
        }
        
        roomIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(35)
            make.top.equalTo(roomIdLabel.snp.bottom).offset(5)
            make.left.equalTo(roomIdLabel)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDTextField)
            make.height.equalTo(roomIDTextField)
            make.top.equalTo(roomIDTextField)
            make.left.equalTo(roomIDTextField.snp.right).offset(10)
        }
        startPushButton.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(userIDTextField)
            make.top.equalTo(userIDTextField)
            make.left.equalTo(userIDTextField.snp.right).offset(10)
        }
        
    }
    
    private func bindInteraction() {
        startPushButton.addTarget(self,action: #selector(clickStartPushButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func clickStartPushButton(sender: UIButton) {
        startPushButton.isSelected = !startPushButton.isSelected
        if startPushButton.isSelected {
            startPushStream()
        }else{
            stopPushStream()
        }
    }
    
    private func startPushStream() {
        title = LocalizeReplace(Localize("TRTC-API-Example.StringRoomId.Title"), roomIDTextField.text ?? "")
        trtcCloud.startLocalPreview(true, view: view)
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(Int(roomIDTextField.text ?? "") ?? 0)
        params.userId = String(arc4random()%(999999 - 100000 + 1)+100000)
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: self.userIDTextField.text ?? "" ) as String
        
        
        trtcCloud.enterRoom(params, appScene: .LIVE)
        trtcCloud.startLocalAudio(.music)
        
        let encParams =  TRTCVideoEncParam()
        encParams.videoResolution = ._960_540
        encParams.videoFps = 24
        encParams.resMode = .portrait
        
        trtcCloud.setVideoEncoderParam(encParams)
        
    }
    private func stopPushStream() {
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
    }
    
    private func destroyTRTCCloud() {
        TRTCCloud.destroySharedIntance()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:
         UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:
         UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti:NSNotification) {
        if  let info:NSDictionary = noti.userInfo as? NSDictionary {
            let keyValue = info.object(forKey: "UIKeyboardFrameEndUserInfoKey")
            let keyRect = (keyValue as AnyObject).cgRectValue
            if let height = keyRect?.size.height {
                UIView.animate(withDuration: 1.0) {
                    self.view.transform = CGAffineTransform.init(translationX: 0, y: 0 - height)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ noti:NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.view.transform =  .identity
        }
    }
}

extension StringRoomIdViewController:UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userIDTextField.resignFirstResponder()
        roomIDTextField.resignFirstResponder()
        return true
    }
}








