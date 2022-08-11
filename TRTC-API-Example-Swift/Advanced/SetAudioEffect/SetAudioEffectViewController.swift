//
//  SetAudioEffectViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
/*
 设置音效功能示例
 TRTC APP 支持设置音效功能
 本文件展示如何集成设置音效功能
 1、进入TRTC房间。 API:trtcCloud.enterRoom(params, appScene: .LIVE)
 2、选择变声。API:trtcCloud.getAudioEffectManager().setVoiceChangerType(._0)
 3、选择混响。 API:trtcCloud.getAudioEffectManager().setVoiceReverbType(._0)
 4、设置TRTC的关键代码。 API：startPushStream()
 参考文档：https://cloud.tencent.com/document/product/647/32258
 */
/*
 Setting Audio Effects
 The TRTC app supports audio effect setting.
 This document shows how to integrate the audio effect setting feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Select a voice change effect: trtcCloud.getAudioEffectManager().setVoiceChangerType(._0)
 3. Select a reverb effect: trtcCloud.getAudioEffectManager().setVoiceReverbType(._0)
 4. Set the key code of TRTC : startPushStream()
 Documentation: https://cloud.tencent.com/document/product/647/32258
 */
class SetAudioEffectViewController : UIViewController {
    
    let trtcCloud = TRTCCloud.sharedInstance()
    let textfieldBottomConstraint = NSLayoutConstraint()
    let remoteUserIdSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
    
    let roomIDLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetAudioEffect.roomId")
        return lable
    }()
    
    let userIDLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetAudioEffect.userId")
        
        return lable
    }()
    
    let voiceChangerLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetAudioEffect.voiceChanger")
        return lable
    }()
    
    let reverberationLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.SetAudioEffect.voiceChanger")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    let leftRemoteUserIDLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 300
        return lable
    }()
    let leftRemoteUserIDLabelB:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 301
        return lable
    }()
    let leftRemoteUserIDLabelC:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 302
        return lable
        
    }()
    let rightRemoteUserIDLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 303
        return lable
    }()
    let rightRemoteUserIDLabelB:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 304
        return lable
    }()
    let rightRemoteUserIDLabelC:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.tag = 305
        return lable
    }()
    
    
    let leftRemoteUserViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 200
        return view
    }()
    
    let leftRemoteUserViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 201
        return view
    }()
    
    let leftRemoteUserViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 202
        return view
    }()
    
    let rightRemoteUserViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 203
        return view
    }()
    
    let rightRemoteUserViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 204
        return view
    }()
    
    let rightRemoteUserViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 205
        return view
    }()
    
    let roomIDTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let userIDTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(999999 - 100000 + 1) + 100000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let originVoiceButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.origin"), for: .normal)
        return button
    }()
    
    let childVoiceButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.child"), for: .normal)
        return button
    }()
    
    let loliVoiceButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.loli"), for: .normal)
        return button
    }()
    
    let metalVoiceButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.metal"), for: .normal)
        return button
    }()
    
    let uncleVoiceButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.uncle"), for: .normal)
        return button
    }()
    
    let normalButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.normal"), for: .normal)
        return button
    }()
    
    let ktvButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.ktv"), for: .normal)
        return button
    }()
    
    let smallRoomButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.smallRoom"), for: .normal)
        return button
    }()
    
    let greatHallButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.greatHall"), for: .normal)
        return button
    }()
    
    let muffledButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.muffled"), for: .normal)
        return button
    }()
    
    let pushStreamButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.SetAudioEffect.stopPush"), for: .selected)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = LocalizeReplace(Localize("TRTC-API-Example.SetAudioEffect.Title"), roomIDTextField.text ?? "")
        trtcCloud.delegate = self
        userIDTextField.delegate = self
        roomIDTextField.delegate = self
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
        title = LocalizeReplace(Localize("TRTC-API-Example.SetAudioEffect.Title"),roomIDTextField.text ?? "")
        
        trtcCloud.startLocalPreview(true, view: view)
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.roomId = UInt32(Int(roomIDTextField.text ?? "") ?? 0)
        params.userId = userIDTextField.text ?? ""
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userIDTextField.text ?? "") as String
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
        
        if remoteUserIdSet.count == 0 {
            trtcCloud.stopRemoteView(userIDTextField.text ?? "", streamType: .small)
            return
        }
        for  i in 0...remoteUserIdSet.count-1 {
            let remoteView = view.viewWithTag(i+200)
            if let remoteLable = view.viewWithTag(i+300) as? UILabel {
                remoteLable.text = ""
            }
            remoteView?.alpha = 0
            guard let userIdSetIndex = remoteUserIdSet[i] as? String else{
                return
            }
            trtcCloud.stopRemoteView(userIdSetIndex, streamType: .small)
        }
        remoteUserIdSet.removeAllObjects()
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(roomIDLabel)
        view.addSubview(userIDLabel)
        view.addSubview(roomIDTextField)
        view.addSubview(userIDTextField)
        view.addSubview(voiceChangerLabel)
        
        view.addSubview(originVoiceButton)
        view.addSubview(childVoiceButton)
        view.addSubview(loliVoiceButton)
        view.addSubview(metalVoiceButton)
        view.addSubview(ktvButton)
        view.addSubview(smallRoomButton)
        
        view.addSubview(uncleVoiceButton)
        view.addSubview(reverberationLabel)
        view.addSubview(normalButton)
        view.addSubview(greatHallButton)
        view .addSubview(muffledButton)
        view .addSubview(pushStreamButton)
        
        view.addSubview(leftRemoteUserViewA)
        view.addSubview(leftRemoteUserViewB)
        view.addSubview(leftRemoteUserViewC)
        view.addSubview(rightRemoteUserViewA)
        view .addSubview(rightRemoteUserViewB)
        view .addSubview(rightRemoteUserViewC)
        
        leftRemoteUserViewA.addSubview(leftRemoteUserIDLabelA)
        leftRemoteUserViewB.addSubview(leftRemoteUserIDLabelB)
        leftRemoteUserViewC.addSubview(leftRemoteUserIDLabelC)
        rightRemoteUserViewA.addSubview(rightRemoteUserIDLabelA)
        rightRemoteUserViewB.addSubview(rightRemoteUserIDLabelB)
        rightRemoteUserViewC.addSubview(rightRemoteUserIDLabelC)
    }
    
    private func activateConstraints() {
        
        leftRemoteUserViewA.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-90)/2)
            make.height.equalTo(172)
            make.left.equalTo(20)
            make.top.equalTo(80)
        }
        
        leftRemoteUserIDLabelA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserViewA)
            make.height.equalTo(17)
            make.left.equalTo(leftRemoteUserViewA)
            make.top.equalTo(leftRemoteUserViewA)
        }
        
        rightRemoteUserViewA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserViewA)
            make.height.equalTo(leftRemoteUserViewA)
            make.left.equalTo(leftRemoteUserViewA.snp.right).offset(50)
            make.top.equalTo(leftRemoteUserViewA)
        }
        
        rightRemoteUserIDLabelA.snp.makeConstraints { make in
            make.width.equalTo(rightRemoteUserViewA)
            make.height.equalTo(leftRemoteUserIDLabelA)
            make.left.equalTo(rightRemoteUserViewA)
            make.top.equalTo(rightRemoteUserViewA)
        }
        
        leftRemoteUserViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserViewA)
            make.height.equalTo(leftRemoteUserViewA)
            make.top.equalTo(leftRemoteUserViewA.snp.bottom).offset(5)
            make.left.equalTo(leftRemoteUserViewA)
        }
        
        
        leftRemoteUserIDLabelB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserViewB)
            make.height.equalTo(leftRemoteUserIDLabelA)
            make.top.equalTo(leftRemoteUserViewB)
            make.left.equalTo(leftRemoteUserViewB)
        }
        
        rightRemoteUserViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserViewB)
            make.height.equalTo(leftRemoteUserViewB)
            make.top.equalTo(leftRemoteUserViewB)
            make.left.equalTo(leftRemoteUserViewB.snp.right).offset(50)
        }
        
        rightRemoteUserIDLabelB.snp.makeConstraints { make in
            make.width.equalTo(rightRemoteUserViewB)
            make.height.equalTo(leftRemoteUserIDLabelB)
            make.top.equalTo(rightRemoteUserViewB)
            make.left.equalTo(rightRemoteUserViewB)
        }
        
        leftRemoteUserViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserIDLabelB)
            make.height.equalTo(leftRemoteUserIDLabelB)
            make.top.equalTo(leftRemoteUserIDLabelB.snp.bottom).offset(5)
            make.left.equalTo(leftRemoteUserIDLabelB)
        }
        leftRemoteUserIDLabelC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserViewC)
            make.height.equalTo(rightRemoteUserIDLabelB)
            make.top.equalTo(leftRemoteUserViewC)
            make.left.equalTo(leftRemoteUserViewC)
        }
        
        rightRemoteUserViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteUserViewC)
            make.height.equalTo(leftRemoteUserViewC)
            make.top.equalTo(leftRemoteUserViewC)
            make.left.equalTo(leftRemoteUserViewC.snp.right).offset(50)
        }
        
        rightRemoteUserIDLabelC.snp.makeConstraints { make in
            make.width.equalTo(rightRemoteUserViewC)
            make.height.equalTo(leftRemoteUserIDLabelC)
            make.top.equalTo(rightRemoteUserViewC)
            make.left.equalTo(rightRemoteUserViewC)
        }
        
        
        voiceChangerLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.bottom).offset(-250)
            make.left.equalTo(20)
        }
        
        originVoiceButton.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width - 80)/5)
            make.height.equalTo(voiceChangerLabel)
            make.top.equalTo(voiceChangerLabel.snp.bottom).offset(10)
            make.left.equalTo(voiceChangerLabel)
        }
        
        childVoiceButton.snp.makeConstraints { make in
            make.width.equalTo(originVoiceButton)
            make.height.equalTo(originVoiceButton)
            make.top.equalTo(originVoiceButton)
            make.left.equalTo(originVoiceButton.snp.right).offset(10)
        }
        
        loliVoiceButton.snp.makeConstraints { make in
            make.width.equalTo(childVoiceButton)
            make.height.equalTo(childVoiceButton)
            make.top.equalTo(childVoiceButton)
            make.left.equalTo(childVoiceButton.snp.right).offset(10)
        }
        
        metalVoiceButton.snp.makeConstraints { make in
            make.width.equalTo(loliVoiceButton)
            make.height.equalTo(loliVoiceButton)
            make.top.equalTo(loliVoiceButton)
            make.left.equalTo(loliVoiceButton.snp.right).offset(10)
        }
        
        uncleVoiceButton.snp.makeConstraints { make in
            make.width.equalTo(metalVoiceButton)
            make.height.equalTo(metalVoiceButton)
            make.top.equalTo(metalVoiceButton)
            make.left.equalTo(metalVoiceButton.snp.right).offset(10)
        }
        
        reverberationLabel.snp.makeConstraints { make in
            make.width.equalTo(voiceChangerLabel)
            make.height.equalTo(voiceChangerLabel)
            make.top.equalTo(originVoiceButton.snp.bottom).offset(10)
            make.left.equalTo(originVoiceButton)
        }
        
        
        normalButton.snp.makeConstraints { make in
            make.width.equalTo(uncleVoiceButton)
            make.height.equalTo(uncleVoiceButton)
            make.top.equalTo(reverberationLabel.snp.bottom).offset(10)
            make.left.equalTo(reverberationLabel)
        }
        
        ktvButton.snp.makeConstraints { make in
            make.width.equalTo(normalButton)
            make.height.equalTo(normalButton)
            make.top.equalTo(normalButton)
            make.left.equalTo(normalButton.snp.right).offset(10)
        }
        
        smallRoomButton.snp.makeConstraints { make in
            make.width.equalTo(ktvButton)
            make.height.equalTo(ktvButton)
            make.top.equalTo(ktvButton)
            make.left.equalTo(ktvButton.snp.right).offset(10)
        }
        
        greatHallButton.snp.makeConstraints { make in
            make.width.equalTo(smallRoomButton)
            make.height.equalTo(smallRoomButton)
            make.top.equalTo(smallRoomButton)
            make.left.equalTo(smallRoomButton.snp.right).offset(10)
        }
        
        muffledButton.snp.makeConstraints { make in
            make.width.equalTo(greatHallButton)
            make.height.equalTo(greatHallButton)
            make.top.equalTo(greatHallButton)
            make.left.equalTo(greatHallButton.snp.right).offset(10)
        }
        
        roomIDLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width - 80)/3)
            make.height.equalTo(normalButton)
            make.top.equalTo(normalButton.snp.bottom).offset(10)
            make.left.equalTo(normalButton)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIDLabel)
            make.height.equalTo(roomIDLabel)
            make.top.equalTo(roomIDLabel)
            make.left.equalTo(roomIDLabel.snp.right).offset(20)
        }
        
        roomIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDLabel)
            make.height.equalTo(roomIDLabel)
            make.top.equalTo(roomIDLabel.snp.bottom).offset(10)
            make.left.equalTo(roomIDLabel)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDTextField)
            make.height.equalTo(roomIDTextField)
            make.top.equalTo(roomIDTextField)
            make.left.equalTo(roomIDTextField.snp.right).offset(20)
        }
        
        pushStreamButton.snp.makeConstraints { make in
            make.width.equalTo(userIDTextField)
            make.height.equalTo(userIDTextField)
            make.top.equalTo(userIDTextField)
            make.left.equalTo(userIDTextField.snp.right).offset(20)
        }
        
    }
    private func bindInteraction() {
        originVoiceButton.addTarget(self,action: #selector(onOriginVoiceClick(sender:)), for: .touchUpInside)
        childVoiceButton.addTarget(self,action: #selector(onChildVoiceClick(sender:)), for: .touchUpInside)
        loliVoiceButton.addTarget(self,action: #selector(onLoliVoiceClick(sender:)), for: .touchUpInside)
        metalVoiceButton.addTarget(self,action: #selector(onMetalVoiceClick(sender:)), for: .touchUpInside)
        uncleVoiceButton.addTarget(self,action: #selector(onGreatHallClick(sender:)), for: .touchUpInside)
        
        normalButton.addTarget(self,action: #selector(onNormalClick(sender:)), for: .touchUpInside)
        ktvButton.addTarget(self,action: #selector(onKtvClick(sender:)), for: .touchUpInside)
        smallRoomButton.addTarget(self,action: #selector(onSmallRoomClick(sender:)), for: .touchUpInside)
        muffledButton.addTarget(self,action: #selector(onMuffledClick(sender:)), for: .touchUpInside)
        pushStreamButton.addTarget(self,action: #selector(onPushStreamClick(sender:)), for: .touchUpInside)
        greatHallButton.addTarget(self,action: #selector(onGreatHallClick(sender:)), for: .touchUpInside)
    }
    
    @objc private func onOriginVoiceClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceChangerType(._0)
    }
    
    @objc private func onChildVoiceClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceChangerType(._1)
    }
    
    @objc private func onLoliVoiceClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceChangerType(._2)
    }
    
    @objc private func onMetalVoiceClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceChangerType(._4)
    }
    
    @objc private func onUncleVoiceClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceChangerType(._3)
    }
    
    @objc private func onNormalClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceReverbType(._0)
    }
    
    @objc private func onKtvClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceReverbType(._1)
    }
    
    @objc private func onSmallRoomClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceReverbType(._2)
    }
    
    @objc private func onGreatHallClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceReverbType(._3)
    }
    
    @objc private func onMuffledClick(sender: UIButton) {
        trtcCloud.getAudioEffectManager().setVoiceReverbType(._4)
    }
    
    @objc private func onPushStreamClick(sender: UIButton) {
        pushStreamButton.isSelected = !pushStreamButton.isSelected
        if pushStreamButton.isSelected {
            startPushStream()
        }else{
            stopPushStream()
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
            if let lable = view?.viewWithTag(count + 300) as? UILabel {
                lable.text = LocalizeReplace(Localize("TRTC-API-Example.SendAndReceiveSEI.UserIdxx"), userId)
            }
            view?.alpha = 1
            trtcCloud.startRemoteView(userId, streamType: .small, view: view)
            
        }
    }
    
    func hiddenRemoteUserViewWith(_ userId:String) {
        let viewTag = remoteUserIdSet.index(of: userId)
        let view = view.viewWithTag(viewTag + 200)
        if let lable = view?.viewWithTag(viewTag + 300) as? UILabel {
            lable.text = ""
        }
        view?.alpha = 0
        trtcCloud.stopRemoteView(userId, streamType: .small)
        remoteUserIdSet.remove(userId)
    }
}

extension SetAudioEffectViewController:UITextFieldDelegate {
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

extension SetAudioEffectViewController:TRTCCloudDelegate {
    func onRemoteUserEnterRoom(_ userId: String) {
        let index = remoteUserIdSet.index(of: userId)
        if index == NSNotFound {
            showRemoteUserViewWith(userId)
        }
    }
    
    func onConnectOtherRoom(_ userId: String, errCode: TXLiteAVError, errMsg: String?) {
        let index = remoteUserIdSet.index(of: userId)
        if index != NSNotFound {
            hiddenRemoteUserViewWith(userId)
        }
    }
}





