//
//  RoomPkViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/28.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
/*
 跨房PK功能
 TRTC 跨房PK
 
 本文件展示如何集成跨房PK
 
 1、连接其他房间 API: trtcCloud.connectOtherRoom(jsonString)
 2、设置TRTC的关键代码 API：setupTRTCCloud()
 参考文档：https://cloud.tencent.com/document/product/647/32258
 */
/*
 Cross-room Competition
 The TRTC app supports cross-room competition.
 
 This document shows how to integrate the cross-room competition feature.
 
 1. Connect to another room: trtcCloud.connectOtherRoom(jsonString)
 2. Set the key code of TRTC : setupTRTCCloud()
 Documentation: https://cloud.tencent.com/document/product/647/32258
 */
class RoomPkViewController : UIViewController {
    
    let bottomConstraint = NSLayoutConstraint()
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let roomIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.RoomPk.roomId")
        return lable
    }()
    
    let userIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.RoomPk.UserId")
        
        return lable
    }()
    
    let otherRoomIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.RoomPk.pkRoomId")
        
        return lable
    }()
    
    let otherUserIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.RoomPk.pkUserId")
        return lable
    }()
    
    let localView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        return view
    }()
    
    let remoteView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        return view
    }()
    
    let roomIdTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random() % (9999999 - 1000000 + 1) + 1000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
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
    
    let otherRoomIdTextField : UITextField = {
        var filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let otherUserIdTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let startButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RoomPk.start"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.RoomPk.stop"), for: .selected)
        return button
    }()
    
    let connectOtherRoomButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RoomPk.startPK"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.RoomPk.stopPK"), for: .selected)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        trtcCloud.delegate = self
        userIdTextField.delegate = self
        roomIdTextField.delegate = self
        otherUserIdTextField.delegate = self
        otherRoomIdTextField.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        refreshPkButton()
        setupRandomRoomId()
        addKeyboardObserver()
    }
    
    deinit {
        destroyTRTCCloud()
        removeKeyboardObserver()
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(roomIdLabel)
        view.addSubview(userIdLabel)
        view.addSubview(otherRoomIdLabel)
        view.addSubview(otherUserIdLabel)
        view.addSubview(localView)
        
        view.addSubview(remoteView)
        view.addSubview(roomIdTextField)
        view.addSubview(userIdTextField)
        view.addSubview(otherRoomIdTextField)
        view.addSubview(otherUserIdTextField)
        
        view.addSubview(startButton)
        view.addSubview(connectOtherRoomButton)
    }
    
    private func activateConstraints() {
        localView.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-46)/2)
            make.height.equalTo(260)
            make.left.equalTo(20)
            make.top.equalTo(90)
        }
        
        remoteView.snp.makeConstraints { make in
            make.width.equalTo(localView)
            make.height.equalTo(localView)
            make.left.equalTo(localView.snp.right).offset(6)
            make.top.equalTo(localView)
        }
        
        otherRoomIdLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-50)/3)
            make.height.equalTo(25)
            make.top.equalTo(view.snp.bottom).offset(-200)
            make.left.equalTo(20)
        }
        
        otherUserIdLabel.snp.makeConstraints { make in
            make.width.equalTo(otherRoomIdLabel)
            make.height.equalTo(otherRoomIdLabel)
            make.top.equalTo(otherRoomIdLabel)
            make.left.equalTo(otherRoomIdLabel.snp.right).offset(5)
        }
        otherRoomIdTextField.snp.makeConstraints { make in
            make.width.equalTo(otherRoomIdLabel)
            make.height.equalTo(otherRoomIdLabel)
            make.top.equalTo(otherRoomIdLabel.snp.bottom).offset(5)
            make.left.equalTo(otherRoomIdLabel)
        }
        
        otherUserIdTextField.snp.makeConstraints { make in
            make.width.equalTo(otherRoomIdTextField)
            make.height.equalTo(otherRoomIdTextField)
            make.top.equalTo(otherRoomIdTextField)
            make.left.equalTo(otherRoomIdTextField.snp.right).offset(5)
        }
        
        connectOtherRoomButton.snp.makeConstraints { make in
            make.width.equalTo(otherUserIdTextField)
            make.height.equalTo(otherUserIdTextField)
            make.top.equalTo(otherUserIdTextField)
            make.left.equalTo(otherUserIdTextField.snp.right).offset(5)
        }
        
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo(otherRoomIdLabel)
            make.height.equalTo(otherRoomIdLabel)
            make.top.equalTo(otherRoomIdTextField.snp.bottom).offset(5)
            make.left.equalTo(otherRoomIdLabel)
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.width.equalTo(otherUserIdLabel)
            make.height.equalTo(otherUserIdLabel)
            make.top.equalTo(otherRoomIdTextField.snp.bottom).offset(5)
            make.left.equalTo(roomIdLabel.snp.right).offset(5)
        }
        roomIdTextField.snp.makeConstraints { make in
            make.width.equalTo(otherRoomIdTextField)
            make.height.equalTo(otherRoomIdTextField)
            make.top.equalTo(roomIdLabel.snp.bottom).offset(5)
            make.left.equalTo(roomIdLabel)
        }
        
        userIdTextField.snp.makeConstraints { make in
            make.width.equalTo(otherRoomIdTextField)
            make.height.equalTo(otherRoomIdTextField)
            make.top.equalTo(roomIdTextField)
            make.left.equalTo(roomIdTextField.snp.right).offset(5)
        }
        
        startButton.snp.makeConstraints { make in
            make.width.equalTo(connectOtherRoomButton)
            make.height.equalTo(connectOtherRoomButton)
            make.top.equalTo(userIdTextField)
            make.left.equalTo(userIdTextField.snp.right).offset(5)
        }
    }
    
    private func bindInteraction() {
        startButton.addTarget(self,action: #selector(clickStartButton(sender:)), for: .touchUpInside)
        connectOtherRoomButton.addTarget(self,action: #selector(clickConnectOtherRoomButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func clickStartButton(sender: UIButton) {
        startButton.isSelected = !startButton.isSelected
        if startButton.isSelected {
            title = Localize("TRTC-API-Example.RoomPk.title").appending(roomIdTextField.text ?? "")
            setupTRTCCloud()
        }else {
            trtcCloud.exitRoom()
            destroyTRTCCloud()
        }
        refreshPkButton()
    }
    
    @objc private func clickConnectOtherRoomButton(sender: UIButton) {
        connectOtherRoomButton.isSelected = !connectOtherRoomButton.isSelected
        if connectOtherRoomButton.isSelected && checkPkRoomAndUserIdIsValid() {
            let jsonDict = ["roomId":Int(otherRoomIdTextField.text ?? "") ?? 0,"userId":otherUserIdTextField.text ?? ""] as [String : Any]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) else { return }
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else { return }
            trtcCloud.connectOtherRoom(jsonString)
        } else {
            connectOtherRoomButton.isSelected = false
            trtcCloud.disconnectOtherRoom()
        }
    }
    
    func checkPkRoomAndUserIdIsValid() -> Bool {
        
        //这里判断正负再看一下
        if !(otherRoomIdTextField.text?.isEmpty ?? true) && otherRoomIdTextField.text != "" {
            if !(otherUserIdTextField.text?.isEmpty ?? true) && otherUserIdTextField.text != "" {
                return true
            }
        }
        return false
    }
    
    func refreshPkButton() {
        if startButton.isSelected{
            connectOtherRoomButton.isEnabled = true
            connectOtherRoomButton.backgroundColor = .green
        }else{
            connectOtherRoomButton.isEnabled = false
            connectOtherRoomButton.backgroundColor = .gray
        }
    }
    
    func setupRandomRoomId() {
        roomIdTextField.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        userIdTextField.text = String(arc4random()%(999999 - 100000 + 1)+100000)
    }
    
    private func setupTRTCCloud() {
        trtcCloud.startLocalPreview(true, view: localView)
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(Int(roomIdTextField.text ?? "") ?? 0)
        params.userId = userIdTextField.text ?? ""
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userIdTextField.text ?? "") as String
        
        trtcCloud.enterRoom(params, appScene: .LIVE)
        
        let encParams =  TRTCVideoEncParam()
        encParams.videoResolution = ._1280_720
        encParams.videoBitrate = 1500
        encParams.videoFps = 15
        
        trtcCloud.setVideoEncoderParam(encParams)
        trtcCloud.startLocalAudio(.default)
    }
    
    private func destroyTRTCCloud() {
        TRTCCloud.destroySharedIntance()
        trtcCloud.exitRoom()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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

extension RoomPkViewController:UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        otherRoomIdTextField.resignFirstResponder()
        otherUserIdTextField.resignFirstResponder()
        userIdTextField.resignFirstResponder()
        return true
    }
}

extension RoomPkViewController:TRTCCloudDelegate {
    func onUserAudioAvailable(_ userId: String, available: Bool) {
        if userId == otherUserIdTextField.text {
            return
        }
        
        if available {
            trtcCloud.startRemoteView(userId, streamType: .small, view: remoteView)
        }
        else {
            trtcCloud.stopRemoteView(userId,streamType: .small)
        }
    }
    
    func onConnectOtherRoom(_ userId: String, errCode: TXLiteAVError, errMsg: String?) {
        if errCode != ERR_NULL {
            showAlertViewController(title: Localize("TRTC-API-Example.RoomPk.connectRoomError"), message: errMsg ?? "")
            connectOtherRoomButton.isSelected = false
        }
    }
    
    func showAlertViewController(title:String,message:String) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Localize("TRTC-API-Example.AlertViewController.determine"), style: .default)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}




