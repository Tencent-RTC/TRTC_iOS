//
//  SetBGMViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/28.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
/*
 设置背景音乐功能示例
 TRTC APP 支持设置背景音乐功能
 本文件展示如何集成设置背景音乐功能
 1、进入TRTC房间。 API:trtcCloud.enterRoom(params, appScene: .LIVE)
 2、播放背景音乐。
 API:trtcCloud.getAudioEffectManager().startPlayMusic(bgmParam) { errCode in } onProgress: { progressMs, durationMs in } onComplete: { errCode in }
 3、暂停背景音乐。  API:trtcCloud.getAudioEffectManager().stopPlayMusic(bgmParam.id)
 4、调整播放的背景音乐音量。API:trtcCloud.getAudioEffectManager().setMusicPlayoutVolume(bgmParam.id, volume: Int(volume))
 5、调整远端播放的背景音乐音量。API:trtcCloud.getAudioEffectManager().setMusicPublishVolume(bgmParam.id, volume: Int(volume))
 6、设置TRTC的关键代码。 API：startPushStream()
 参考文档：https://cloud.tencent.com/document/product/647/32258
 */
/*
 Setting Background Music
 The TRTC app supports background music setting.
 This document shows how to integrate the background music setting feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Play background music:
 trtcCloud.getAudioEffectManager().startPlayMusic(bgmParam) { errCode in } onProgress: { progressMs, durationMs in } onComplete: { errCode in }
 3. Pause background music: trtcCloud.getAudioEffectManager().stopPlayMusic(bgmParam.id)
 4. Adjust the playback volume of background music: trtcCloud.getAudioEffectManager().setMusicPlayoutVolume(bgmParam.id, volume: Int(volume))
 5. Adjust the remote playback volume of background music: trtcCloud.getAudioEffectManager().setMusicPublishVolume(bgmParam.id, volume: Int(volume))
 6. Set the key code of TRTC : startPushStream()
 Documentation: https://cloud.tencent.com/document/product/647/32258
 */
class SetBGMViewController : UIViewController {
    
    let trtcCloud = TRTCCloud.sharedInstance()
    let bottomConstraint = NSLayoutConstraint()
    let bgmParam = TXAudioMusicParam()
    let remoteUserIdSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
    let bgmURLArray = ["https://sdk-liteav-1252463788.cos.ap-hongkong.myqcloud.com/app/res/bgm/trtc/PositiveHappyAdvertising.mp3",
                       "https://sdk-liteav-1252463788.cos.ap-hongkong.myqcloud.com/app/res/bgm/trtc/SadCinematicPiano.mp3",
                       "https://sdk-liteav-1252463788.cos.ap-hongkong.myqcloud.com/app/res/bgm/trtc/WonderWorld.mp3"]
    
    let roomIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetBGM.roomId")
        return lable
    }()
    
    let userIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetBGM.userId")
        
        return lable
    }()
    
    let bgmVolumeLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetBGM.setBgmVolume")
        
        return lable
    }()
    
    let bgmLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetBGM.bgmChanger")
        return lable
    }()
    
    let bgmVolumeSlider : UISlider = {
        let slider = UISlider(frame: .zero)
        slider.isContinuous = true
        slider.maximumValue = 1.5
        return slider
    }()
    
    let bgmVolumeNumberLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
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
    
    let rightRemoteLabelB:UILabel = {
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
    
    let roomIDTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random() % (9999999 - 1000000 + 1) + 1000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let userIDTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random() % (999999 - 100000 + 1) + 100000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let startPushButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetBGM.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.SetBGM.stopPush"), for: .selected)
        return button
    }()
    
    let bgmButtonA : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetBGM.bgm1"), for: .normal)
        return button
    }()
    
    let bgmButtonB : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetBGM.bgm2"), for: .normal)
        return button
    }()
    
    let bgmButtonC : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetBGM.bgm3"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        trtcCloud.delegate = self
        userIDTextField.delegate = self
        roomIDTextField.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        addKeyboardObserver()
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
        trtcCloud.enterRoom(params, appScene: .voiceChatRoom)
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
            trtcCloud.stopRemoteView(userIDTextField.text ?? "", streamType: .small)
            return
        }
        for  i in 0...remoteUserIdSet.count-1 {
            let remoteView = view.viewWithTag(i+200)
            remoteView?.alpha = 0
            guard let userStr = remoteUserIdSet[i] as? String else {
                continue
            }
            if let remoteLable = view.viewWithTag(i+300) as? UILabel {
                remoteLable.text = ""
            }
            trtcCloud.stopRemoteView(userStr, streamType: .small)
        }
        remoteUserIdSet.removeAllObjects()
    }
    
    deinit {
        removeKeyboardObserver()
        trtcCloud.stopLocalAudio()
        trtcCloud.stopLocalPreview()
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(startPushButton)
        view.addSubview(bgmButtonA)
        view.addSubview(bgmButtonB)
        view.addSubview(bgmButtonC)
        view.addSubview(roomIdLabel)
        view.addSubview(bgmVolumeSlider)
        
        view.addSubview(userIdLabel)
        view.addSubview(bgmVolumeLabel)
        view.addSubview(bgmLabel)
        view.addSubview(bgmVolumeNumberLabel)
        
        view.addSubview(leftRemoteViewA)
        view.addSubview(leftRemoteViewB)
        view.addSubview(leftRemoteViewC)
        view.addSubview(rightRemoteViewA)
        view .addSubview(rightRemoteViewB)
        view .addSubview(rightRemoteViewC)
        
        leftRemoteViewA.addSubview(leftRemoteLabelA)
        leftRemoteViewB.addSubview(leftRemoteLabelB)
        leftRemoteViewC.addSubview(leftRemoteLabelC)
        rightRemoteViewA.addSubview(rightRemoteLabelA)
        rightRemoteViewB.addSubview(rightRemoteLabelB)
        rightRemoteViewC.addSubview(rightRemoteLabelC)
        
        view .addSubview(roomIDTextField)
        view .addSubview(userIDTextField)
        
        bgmVolumeNumberLabel.text = String(bgmVolumeSlider.value)
    }
    
    private func activateConstraints() {
        
        leftRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-56)/2)
            make.height.equalTo(172)
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
        
        bgmLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width - 60)/3)
            make.height.equalTo(25)
            make.top.equalTo(view.snp.bottom).offset(-250)
            make.left.equalTo(leftRemoteLabelC)
        }
        
        bgmButtonA.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.height.equalTo(30)
            make.top.equalTo(bgmLabel.snp.bottom).offset(10)
            make.left.equalTo(bgmLabel)
        }
        
        bgmButtonB.snp.makeConstraints { make in
            make.width.equalTo(bgmButtonA)
            make.height.equalTo(bgmButtonA)
            make.top.equalTo(bgmButtonA)
            make.left.equalTo(bgmButtonA.snp.right).offset(10)
        }
        
        bgmButtonC.snp.makeConstraints { make in
            make.width.equalTo(bgmButtonA)
            make.height.equalTo(bgmButtonA)
            make.top.equalTo(bgmButtonB)
            make.left.equalTo(bgmButtonB.snp.right).offset(10)
        }
        
        bgmVolumeLabel.snp.makeConstraints { make in
            make.width.equalTo(bgmLabel)
            make.height.equalTo(bgmLabel)
            make.top.equalTo(bgmButtonA.snp.bottom).offset(10)
            make.left.equalTo(bgmButtonA)
        }
        
        bgmVolumeSlider.snp.makeConstraints { make in
            make.width.equalTo(328)
            make.height.equalTo(36)
            make.top.equalTo(bgmVolumeLabel.snp.bottom).offset(10)
            make.left.equalTo(bgmVolumeLabel)
        }
        bgmVolumeNumberLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(25)
            make.top.equalTo(bgmVolumeSlider)
            make.left.equalTo(bgmVolumeSlider.snp.right).offset(10)
        }
        
        
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo(bgmLabel)
            make.height.equalTo(bgmLabel)
            make.top.equalTo(bgmVolumeSlider.snp.bottom).offset(10)
            make.left.equalTo(bgmLabel)
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(roomIdLabel)
            make.top.equalTo(roomIdLabel)
            make.left.equalTo(roomIdLabel.snp.right).offset(10)
        }
        
        roomIDTextField.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(34)
            make.top.equalTo(roomIdLabel.snp.bottom).offset(10)
            make.left.equalTo(roomIdLabel)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDTextField)
            make.height.equalTo(roomIDTextField)
            make.top.equalTo(roomIDTextField)
            make.left.equalTo(roomIDTextField.snp.right).offset(10)
        }
        
        startPushButton.snp.makeConstraints { make in
            make.width.equalTo(userIDTextField)
            make.height.equalTo(userIDTextField)
            make.top.equalTo(userIDTextField)
            make.left.equalTo(userIDTextField.snp.right).offset(10)
        }
    }
    
    private func bindInteraction() {
        startPushButton.addTarget(self,action: #selector(clickStartPushButton(sender:)), for: .touchUpInside)
        bgmButtonA.addTarget(self,action: #selector(clickBgmButtonA(sender:)), for: .touchUpInside)
        bgmButtonB.addTarget(self,action: #selector(clickBgmButtonB(sender:)), for: .touchUpInside)
        bgmButtonC.addTarget(self,action: #selector(clickBgmButtonC(sender:)), for: .touchUpInside)
        bgmVolumeSlider.addTarget(self,action: #selector(bgmSliderValueChange(slider:)), for: .valueChanged)
    }
    
    @objc private func clickBgmButtonA(sender: UIButton) {
        if bgmParam.id > 0 {
            trtcCloud.getAudioEffectManager().stopPlayMusic(bgmParam.id)
        }
        let path = bgmURLArray[0]
        bgmParam.id = 1234
        bgmParam.path = path
        bgmParam.publish = true
        trtcCloud.getAudioEffectManager().startPlayMusic(bgmParam) { errCode in
            
        } onProgress: { progressMs, durationMs in
            
        } onComplete: { errCode in
            
        }
    }
    
    @objc private func clickBgmButtonB(sender: UIButton) {
        if bgmParam.id > 0 {
            trtcCloud.getAudioEffectManager().stopPlayMusic(bgmParam.id)
        }
        let path = bgmURLArray[1]
        bgmParam.id = 2234
        bgmParam.path = path
        bgmParam.publish = true
        trtcCloud.getAudioEffectManager().startPlayMusic(bgmParam) { errCode in
            
        } onProgress: { progressMs, durationMs in
            
        } onComplete: { errCode in
            
        }
    }
    
    @objc private func clickBgmButtonC(sender: UIButton) {
        if bgmParam.id > 0 {
            trtcCloud.getAudioEffectManager().stopPlayMusic(bgmParam.id)
        }
        let path = bgmURLArray[2]
        bgmParam.id = 3234
        bgmParam.path = path
        bgmParam.publish = true
        trtcCloud.getAudioEffectManager().startPlayMusic(bgmParam) { errCode in
            
        } onProgress: { progressMs, durationMs in
            
        } onComplete: { errCode in
            
        }
    }
    
    @objc private func clickStartPushButton(sender: UIButton) {
        startPushButton.isSelected = !startPushButton.isSelected
        if startPushButton.isSelected {
            startPushStream()
        }else {
            stopPushStream()
        }
    }
    
    @objc private func bgmVolumeSliderValueChange(sender: UIButton) {
        let volume = bgmVolumeSlider.value
        bgmVolumeNumberLabel.text = String(volume)
        if bgmParam.id == 0 {
            return
        }
        trtcCloud.getAudioEffectManager().setMusicPlayoutVolume(bgmParam.id, volume: Int(volume))
        trtcCloud.getAudioEffectManager().setMusicPublishVolume(bgmParam.id, volume: Int(volume))
    }
    
    @objc private func bgmSliderValueChange(slider: UISlider) {
        let index =  Int(bgmVolumeSlider.value * 100)
        bgmVolumeNumberLabel.text = String(index)
        if bgmParam.id == 0 {
            return
        }
        trtcCloud.getAudioEffectManager().setMusicPublishVolume(bgmParam.id, volume: Int(index))
        trtcCloud.getAudioEffectManager().setMusicPlayoutVolume(bgmParam.id, volume: Int(index))
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

extension SetBGMViewController:UITextFieldDelegate {
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

extension SetBGMViewController:TRTCCloudDelegate {
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




