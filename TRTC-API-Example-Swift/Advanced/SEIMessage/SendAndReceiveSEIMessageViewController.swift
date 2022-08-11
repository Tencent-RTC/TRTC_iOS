//
//  SendAndReceiveSEIMessageViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC
/*
 收发SEI消息功能示例
 TRTC APP 支持收发SEI消息功能
 本文件展示如何集成收发SEI消息功能
 1、进入TRTC房间。API:trtcCloud.enterRoom(params, appScene: .LIVE)
 2、发送SEI消息。 API:trtcCloud.sendSEIMsg(SEIData, repeatCount: 1)
 3、接收SEI消息。 API：TRTCCloudDelegate：func onRecvSEIMsg(_ userId: String, message: Data)
 4、设置TRTC的关键代码。 API：startPushStream（）
 参考文档：https://cloud.tencent.com/document/product/647/32241
 */
/*
 SEI Message Receiving/Sending
 The TRTC app supports sending and receiving SEI messages.
 This document shows how to integrate the SEI message sending/receiving feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Send SEI messages: trtcCloud.sendSEIMsg(SEIData, repeatCount: 1)
 3. Receive SEI messages: TRTCCloudDelegate：func onRecvSEIMsg(_ userId: String, message: Data)
 4. Set the key code of TRTC : startPushStream（）
 Documentation: https://cloud.tencent.com/document/product/647/32241
 */
let SEIMessage = "TRTC-API-Example.SendAndReceiveSEI.SEIMessage"
class SendAndReceiveSEIMessageViewController : UIViewController {
    
    let trtcCloud = TRTCCloud.sharedInstance()
    let remoteUserIdSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
    let textfieldBottomConstraint = NSLayoutConstraint()
    
    let leftRemoteLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 300
        return lable
    }()
    
    let leftRemoteLabelB:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 301
        return lable
    }()
    
    let leftRemoteLabelC:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 302
        return lable
    }()
    
    let rightRemoteLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 303
        return lable
    }()
    
    let rightRemoteLabelB : UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 304
        return lable
    }()
    
    let rightRemoteLabelC:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 305
        return lable
    }()
    
    let seiMessageLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = .center
        return lable
    }()
    
    let roomIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SendAndReceiveSEI.roomId")
        return lable
    }()
    
    let userIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SendAndReceiveSEI.userId")
        return lable
    }()
    
    let seiMessageDescLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SendAndReceiveSEI.SEIMessageDesc")
        return lable
    }()
    
    
    let leftRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 200
        return view
    }()
    
    let leftRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 201
        return view
    }()
    
    let leftRemoteViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 202
        return view
    }()
    
    let rightRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 203
        return view
    }()
    
    let rightRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 204
        return view
    }()
    
    let rightRemoteViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 205
        return view
    }()
    
    let seiMessageView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.layer.borderWidth = 0.5
        view.alpha = 0
        view.tag = 204
        return view
    }()
    
    let roomIdTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let userIdTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let seiMessageTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = Localize(SEIMessage)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let startPushStreamButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SendAndReceiveSEI.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.SendAndReceiveSEI.stopPush"), for: .selected)
        return button
    }()
    
    let sendSEIMessageButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SendAndReceiveSEI.SendSEIBtn"), for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = LocalizeReplace(Localize("TRTC-API-Example.SetAudioEffect.Title"), roomIdTextField.text ?? "")
        trtcCloud.delegate = self
        userIdTextField.delegate = self
        roomIdTextField.delegate = self
        seiMessageTextField.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        addKeyboardObserver()
    }
    
    deinit {
        removeKeyboardObserver()
        trtcCloud.stopLocalAudio()
        trtcCloud.stopLocalPreview()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    private func startPushStream() {
        title = LocalizeReplace(Localize("TRTC-API-Example.SendAndReceiveSEI.Title"),roomIdTextField.text ?? "")
        trtcCloud.startLocalPreview(true, view: view)
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.roomId = UInt32(Int(roomIdTextField.text ?? "") ?? 0)
        params.userId = userIdTextField.text ?? ""
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userIdTextField.text ?? "") as String
        params.role = .anchor
        
        trtcCloud.delegate = self
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
        leftRemoteViewA.alpha = 0
        if remoteUserIdSet.count == 0 {
            trtcCloud.stopRemoteView(userIdTextField.text ?? "", streamType: .small)
            return
        }
        for  i in 0...remoteUserIdSet.count-1 {
            let remoteView = view.viewWithTag(i+200)
            if let remoteLable = view.viewWithTag(i+300) as? UILabel {
                remoteLable.text = ""
            }
            remoteView?.alpha = 0
            guard let userStr = remoteUserIdSet[i] as? String else {
                continue
            }
            trtcCloud.stopRemoteView(userStr, streamType: .small)
        }
        remoteUserIdSet.removeAllObjects()
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(leftRemoteViewA)
        view.addSubview(leftRemoteViewB)
        view.addSubview(leftRemoteViewC)
        view.addSubview(rightRemoteViewA)
        view.addSubview(rightRemoteViewB)
        view.addSubview(rightRemoteViewC)
        view.addSubview(seiMessageView)
        seiMessageView.addSubview(seiMessageLabel)
        
        leftRemoteViewA.addSubview(leftRemoteLabelA)
        leftRemoteViewB.addSubview(leftRemoteLabelB)
        leftRemoteViewC.addSubview(leftRemoteLabelC)
        rightRemoteViewA.addSubview(rightRemoteLabelA)
        rightRemoteViewB.addSubview(rightRemoteLabelB)
        rightRemoteViewC.addSubview(rightRemoteLabelC)
        
        view.addSubview(roomIdLabel)
        view.addSubview(userIdLabel)
        view.addSubview(seiMessageDescLabel)
        view.addSubview(roomIdTextField)
        view.addSubview(roomIdLabel)
        view.addSubview(userIdTextField)
        
        view.addSubview(seiMessageTextField)
        view.addSubview(startPushStreamButton)
        view.addSubview(sendSEIMessageButton)
    }
    
    private func activateConstraints() {
        
        leftRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-90)/2)
            make.height.equalTo(150)
            make.left.equalTo(20)
            make.top.equalTo(80)
        }
        
        leftRemoteLabelA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(17)
            make.left.equalTo(leftRemoteViewA)
            make.top.equalTo(leftRemoteViewA)
        }
        
        rightRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.left.equalTo(leftRemoteViewA.snp.right).offset(50)
            make.top.equalTo(leftRemoteViewA)
        }
        
        rightRemoteLabelA.snp.makeConstraints { make in
            make.width.equalTo(rightRemoteViewA)
            make.height.equalTo(leftRemoteLabelA)
            make.left.equalTo(rightRemoteViewA)
            make.top.equalTo(rightRemoteViewA)
        }
        
        leftRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.top.equalTo(leftRemoteViewA.snp.bottom).offset(5)
            make.left.equalTo(leftRemoteViewA)
        }
        
        
        leftRemoteLabelB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteLabelA)
            make.top.equalTo(leftRemoteViewB)
            make.left.equalTo(leftRemoteViewB)
        }
        
        rightRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteViewB)
            make.top.equalTo(leftRemoteViewB)
            make.left.equalTo(leftRemoteViewB.snp.right).offset(50)
        }
        
        rightRemoteLabelB.snp.makeConstraints { make in
            make.width.equalTo(rightRemoteViewB)
            make.height.equalTo(leftRemoteLabelA)
            make.top.equalTo(rightRemoteViewB)
            make.left.equalTo(rightRemoteViewB)
        }
        
        leftRemoteViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteViewB)
            make.top.equalTo(leftRemoteViewB.snp.bottom).offset(5)
            make.left.equalTo(leftRemoteViewB)
        }
        leftRemoteLabelC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewC)
            make.height.equalTo(leftRemoteLabelA)
            make.top.equalTo(leftRemoteViewC)
            make.left.equalTo(leftRemoteViewC)
        }
        
        rightRemoteViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewC)
            make.height.equalTo(leftRemoteViewC)
            make.top.equalTo(leftRemoteViewC)
            make.left.equalTo(leftRemoteViewC.snp.right).offset(50)
        }
        
        rightRemoteLabelC.snp.makeConstraints { make in
            make.width.equalTo(rightRemoteViewC)
            make.height.equalTo(leftRemoteLabelA)
            make.top.equalTo(rightRemoteViewC)
            make.left.equalTo(rightRemoteViewC)
        }
        
        
        seiMessageView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.bottom).offset(-200)
            make.centerX.equalTo(view)
        }
        
        seiMessageLabel.snp.makeConstraints { make in
            make.width.equalTo(seiMessageView)
            make.height.equalTo(seiMessageView)
            make.top.equalTo(seiMessageView)
            make.left.equalTo(seiMessageView)
        }
        
        seiMessageDescLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(seiMessageView.snp.bottom).offset(10)
            make.left.equalTo(20)
        }
        
        seiMessageTextField.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(30)
            make.top.equalTo(seiMessageDescLabel.snp.bottom).offset(10)
            make.left.equalTo(seiMessageDescLabel)
        }
        
        sendSEIMessageButton.snp.makeConstraints { make in
            make.left.equalTo(seiMessageTextField.snp.right).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(seiMessageTextField)
            make.top.equalTo(seiMessageTextField)
        }
        
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(20)
            make.top.equalTo(seiMessageTextField.snp.bottom).offset(10)
            make.left.equalTo(seiMessageTextField)
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(roomIdLabel)
            make.top.equalTo(roomIdLabel)
            make.left.equalTo(roomIdLabel.snp.right).offset(20)
        }
        
        roomIdTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(seiMessageTextField)
            make.top.equalTo(roomIdLabel.snp.bottom).offset(10)
            make.left.equalTo(roomIdLabel)
        }
        userIdTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIdTextField)
            make.height.equalTo(roomIdTextField)
            make.top.equalTo(roomIdTextField)
            make.left.equalTo(roomIdTextField.snp.right).offset(20)
        }
        
        
        startPushStreamButton.snp.makeConstraints { make in
            make.width.equalTo(sendSEIMessageButton)
            make.height.equalTo(sendSEIMessageButton)
            make.top.equalTo(userIdTextField)
            make.left.equalTo(sendSEIMessageButton)
        }
    }
    
    private func bindInteraction() {
        startPushStreamButton.addTarget(self,action: #selector(onPushStreamClick(sender:)), for: .touchUpInside)
        sendSEIMessageButton.addTarget(self,action: #selector(onSendSEIMessageClick(sender:)), for: .touchUpInside)
        seiMessageTextField.addTarget(self,action: #selector(textFiledDidChange(textFiled:)), for: .editingChanged)
    }
    
    @objc private func onSendSEIMessageClick(sender: UIButton) {
        
        if let SEIData = seiMessageTextField.text?.data(using: .utf8) {
            trtcCloud.sendSEIMsg(SEIData, repeatCount: 1)
        }
        seiMessageLabel.text = LocalizeReplace(Localize("TRTC-API-Example.SendAndReceiveSEI.SendSEIxx"), seiMessageTextField.text ?? "")
        UIView.animate(withDuration: 1) {
            self.seiMessageView.alpha = 1
        } completion: { finish in
            UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut) {
                self.seiMessageView.alpha = 0
            } completion: { finish in
                
            }
        }
    }
    
    @objc private func onPushStreamClick(sender: UIButton) {
        startPushStreamButton.isSelected = !startPushStreamButton.isSelected
        if startPushStreamButton.isSelected {
            startPushStream()
        }else{
            stopPushStream()
        }
    }
    
    @objc private func textFiledDidChange(textFiled : UITextField) {
        if  let length = textFiled.text?.count {
            if length >= 10{
                if let start = textFiled.text?.startIndex {
                    let offsetIndex = textFiled.text?.index(start, offsetBy: 10)
                    if let offsetIndex = offsetIndex {
                        textFiled.text = textFiled.text?.substring(to: offsetIndex)
                    }
                }
            }
        }
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
    
    
    func showRemoteUserViewWith(_ userId:String) {
        if remoteUserIdSet.count < maxRemoteUserNum {
            let count = remoteUserIdSet.count
            remoteUserIdSet.add(userId)
            let view = view.viewWithTag(count + 200)
            if let lable = view?.viewWithTag(count + 300) as? UILabel{
                lable.text = LocalizeReplace(Localize("TRTC-API-Example.SendAndReceiveSEI.UserIdxx"), userId)
            }
            view?.alpha = 1
            trtcCloud.startRemoteView(userId, streamType: .small, view: view)
        }
    }
    
    func hiddenRemoteUserViewWith(_ userId:String) {
        let viewTag = remoteUserIdSet.index(of: userId)
        let view = view.viewWithTag(viewTag + 200)
        if let lable = view?.viewWithTag(viewTag + 300) as? UILabel{
            lable.text = ""
        }
        view?.alpha = 1
        trtcCloud.stopRemoteView(userId, streamType: .small)
        remoteUserIdSet.remove(userId)
    }
}

extension SendAndReceiveSEIMessageViewController:UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userIdTextField.resignFirstResponder()
        seiMessageTextField.resignFirstResponder()
        roomIdTextField.resignFirstResponder()
        return true
    }
}

extension SendAndReceiveSEIMessageViewController:TRTCCloudDelegate {
    func onRemoteUserEnterRoom(_ userId: String) {
        let index = remoteUserIdSet.index(of: userId)
        if index == NSNotFound{
            showRemoteUserViewWith(userId)
        }
    }
    
    func onConnectOtherRoom(_ userId: String, errCode: TXLiteAVError, errMsg: String?) {
        let index = remoteUserIdSet.index(of: userId)
        if index != NSNotFound{
            hiddenRemoteUserViewWith(userId)
        }
    }
    
    func onRecvSEIMsg(_ userId: String, message: Data) {
        if let SEIMessage = String(data: message, encoding: String.Encoding.utf8) {
            seiMessageLabel.text = LocalizeReplaceTwoCharacter(origin: Localize("TRTC-API-Example.SendAndReceiveSEI.ReceiveSEIxxyy"), xxx_replace: userId, yyy_replace: SEIMessage)
            UIView.animate(withDuration: 1) {
                self.seiMessageView.alpha = 1
            } completion: { finish in
                UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut) {
                    self.seiMessageView.alpha = 0
                } completion: { finish in
                    
                }
            }
        }
    }
}





