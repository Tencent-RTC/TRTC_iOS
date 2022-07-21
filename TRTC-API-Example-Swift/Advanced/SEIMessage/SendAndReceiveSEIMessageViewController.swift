//
//  SendAndReceiveSEIMessageViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//
/*
 收发SEI消息功能示例
 TRTC APP 支持收发SEI消息功能
 本文件展示如何集成收发SEI消息功能
 1、进入TRTC房间。API:[self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
 2、发送SEI消息。 API:[self.trtcCloud sendSEIMsg:SEIData repeatCount:1];
 3、接收SEI消息。 API：TRTCCloudDelegate：- (void)onRecvSEIMsg:(NSString *)userId message:(NSData *)message;
 参考文档：https://cloud.tencent.com/document/product/647/32241
 */
/*
 SEI Message Receiving/Sending
 The TRTC app supports sending and receiving SEI messages.
 This document shows how to integrate the SEI message sending/receiving feature.
 1. Enter a room: [self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE]
 2. Send SEI messages: [self.trtcCloud sendSEIMsg:SEIData repeatCount:1]
 3. Receive SEI messages: TRTCCloudDelegate：- (void)onRecvSEIMsg:(NSString *)userId message:(NSData *)message
 Documentation: https://cloud.tencent.com/document/product/647/32241
 */

import Foundation
import UIKit
import TXLiteAVSDK_TRTC

let SEIMessage = "TRTC-API-Example.SendAndReceiveSEI.SEIMessage"
let RemoteUserMaxNum = 0
class SendAndReceiveSEIMessageViewController : UIViewController{
    
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
    
    private func startPushStream(){
        title = LocalizeReplace("TRTC-API-Example.SendAndReceiveSEI.Title",roomIdTextField.text ?? "")
        trtcCloud.startLocalPreview(true, view: view)
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.roomId = UInt32((roomIdTextField.text! as NSString).integerValue)
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
     private func stopPushStream(){
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
         leftRemoteViewA.alpha = 0
         if remoteUserIdSet.count == 0{
             trtcCloud.stopRemoteView(userIdTextField.text ?? "", streamType: .small)
             return
         }
        for  i in 0...remoteUserIdSet.count{
            let remoteView = view.viewWithTag(i+200)
            let remoteLable = view.viewWithTag(i+300) as! UILabel
            remoteView?.alpha = 0
            remoteLable.text = ""
            trtcCloud.stopRemoteView(remoteUserIdSet[i] as! String, streamType: .small)
        }
        remoteUserIdSet.removeAllObjects()
    }
    
    let trtcCloud = TRTCCloud.sharedInstance()
    let remoteUserIdSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
    let textfieldBottomConstraint = NSLayoutConstraint()
    
    let leftRemoteLabelA:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 300
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let leftRemoteLabelB:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        lable.tag = 301
        
        return lable
    }()
    
    let leftRemoteLabelC:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        lable.tag = 302
        
        return lable
    }()
    
    let rightRemoteLabelA:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 303
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let rightRemoteLabelB : UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 304
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let rightRemoteLabelC:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        lable.tag = 305
        return lable
    }()
    
    let seiMessageLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        lable.textAlignment = .center
        return lable
    }()
    
    let roomIdLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SendAndReceiveSEI.roomId")
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let userIdLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SendAndReceiveSEI.userId")
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let seiMessageDescLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SendAndReceiveSEI.SEIMessageDesc")
//        lable.backgroundColor = .gray
        return lable
    }()
    
    
    let leftRemoteViewA:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 200
        
        return view
    }()
    
    let leftRemoteViewB:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 201
        return view
    }()
    
    let leftRemoteViewC:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 202
        return view
    }()
    
    let rightRemoteViewA:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 203
        return view
    }()
    
    let rightRemoteViewB:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 204
        return view
    }()
    
    let rightRemoteViewC:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 205
        return view
    }()
    
    let seiMessageView:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.layer.borderWidth = 0.5
        view.alpha = 0
        view.tag = 204
        return view
    }()
    
    let roomIdTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let userIdTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let seiMessageTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = Localize(SEIMessage)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let startPushStreamButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SendAndReceiveSEI.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.SendAndReceiveSEI.stopPush"), for: .selected)
        return button
    }()
    
    let sendSEIMessageButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SendAndReceiveSEI.SendSEIBtn"), for: .normal)
        return button
    }()
    
}

extension SendAndReceiveSEIMessageViewController{
    
    private func setupDefaultUIConfig(){
        
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
    
    private func activateConstraints(){
        
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
            make.top.equalTo(rightRemoteViewC.snp.bottom).offset(10)
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
            make.height.equalTo(roomIdLabel)
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
    private func bindInteraction(){
        startPushStreamButton.addTarget(self, action: #selector(onPushStreamClick), for: .touchUpInside)
        sendSEIMessageButton.addTarget(self, action: #selector(onSendSEIMessageClick), for: .touchUpInside)
        seiMessageTextField.addTarget(self, action: #selector(textFiledDidChange), for: .editingChanged)
        }
}
extension SendAndReceiveSEIMessageViewController{
    @objc private func onSendSEIMessageClick(){
       
        if let SEIData = seiMessageTextField.text?.data(using: .utf8){
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
    
    @objc private func onPushStreamClick(){
        startPushStreamButton.isSelected = !startPushStreamButton.isSelected
        if startPushStreamButton.isSelected{
            startPushStream()
        }else{
            stopPushStream()
        }
    }
    
    @objc private func textFiledDidChange(textFiled : UITextField){
        if  let length = textFiled.text?.count{
            if length >= 10{
                if let start = textFiled.text?.startIndex{
                    let offsetIndex = textFiled.text?.index(start, offsetBy: 10)
                    if let offsetIndex = offsetIndex{
                        textFiled.text = textFiled.text?.substring(to: offsetIndex)
                    }
                }
                
            }
        }
    }
}

extension SendAndReceiveSEIMessageViewController{
    
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func dealloc(){
        removeKeyboardObserver()
        trtcCloud.stopLocalAudio()
        trtcCloud.stopLocalPreview()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    @objc func keyboardWillShow(_ noti:NSNotification){
        let animationDuration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        let keyboardBounds = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        UIView.animate(withDuration: animationDuration as! TimeInterval) { [self] in
            self.textfieldBottomConstraint.constant = (keyboardBounds as! CGRect).size.height
        }
    }
    
    @objc func keyboardWillHide(_ noti:NSNotification){
        let animationDuration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        
        UIView.animate(withDuration:animationDuration as! TimeInterval) { [self] in
            self.textfieldBottomConstraint.constant = 25
        }
    }
    
    func showRemoteUserViewWith(_ userId:String){
        if remoteUserIdSet.count < maxRemoteUserNum{
            let count = remoteUserIdSet.count
            remoteUserIdSet.add(userId)
            let view = view.viewWithTag(count + 200)
            let lable = view?.viewWithTag(count + 300) as! UILabel
            view?.alpha = 1
            lable.text = LocalizeReplace("TRTC-API-Example.SendAndReceiveSEI.UserIdxx", userId)
            trtcCloud.startRemoteView(userId, streamType: .small, view: view)
            
        }
    }
    
    func hiddenRemoteUserViewWith(_ userId:String){
        let viewTag = remoteUserIdSet.index(of: userId)
        let view = view.viewWithTag(viewTag + 200)
        let lable = view?.viewWithTag(viewTag + 300) as! UILabel
        view?.alpha = 1
        lable.text = ""
        trtcCloud.stopRemoteView(userId, streamType: .small)
        remoteUserIdSet.remove(userId)
    }
}

extension SendAndReceiveSEIMessageViewController:UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        userIdTextField.resignFirstResponder()
        roomIdTextField.resignFirstResponder()
        seiMessageTextField.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userIdTextField.resignFirstResponder()
        seiMessageTextField.resignFirstResponder()
        return roomIdTextField.resignFirstResponder()
    }
}

extension SendAndReceiveSEIMessageViewController:TRTCCloudDelegate{
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
        if let SEIMessage = String(data: message, encoding: String.Encoding.utf8){
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





