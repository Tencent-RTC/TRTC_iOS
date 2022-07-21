//
//  SetAudioQualityViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//
/*
 设置音频质量功能
 TRTC APP 设置音频质量功能
 本文件展示如何集成设置音频质量功能
 1、设置音频质量 API: [self.trtcCloud startLocalAudio:_audioQuality];
 2、设置采集音量 API: [self.trtcCloud setAudioCaptureVolume:(UInt32)_volumeSlider.value];
 参考文档：https://cloud.tencent.com/document/product/647/32258
 */
/*
 Setting Audio Quality
 TRTC Audio Quality Setting
 This document shows how to integrate the audio quality setting feature.
 1. Set audio quality: [self.trtcCloud startLocalAudio:_audioQuality]
 2. Set capturing volume: [self.trtcCloud setAudioCaptureVolume:(UInt32)_volumeSlider.value]
 Documentation: https://cloud.tencent.com/document/product/647/32258
 */

import Foundation
import UIKit
import TXLiteAVSDK_TRTC

class SetAudioQualityViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = Localize("TRTC-API-Example.SetAudioQuality.Title").appending(roomIdTextField.text ?? "" )
        trtcCloud.delegate = self
        userIdTextField.delegate = self
        roomIdTextField.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        addKeyboardObserver()
        audioQuality = .default
        running = false
        
    }
   
    let trtcCloud = TRTCCloud.sharedInstance()
    let bottomConstraint = NSLayoutConstraint()
    var remoteViewArr = [UIView]()
    var running = false
    var audioQuality = TRTCAudioQuality.init(rawValue: 0)
    let remoteUidSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
   
    
    let roomIdLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetAudioQuality.roomId")
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let userIdLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        lable.text = Localize("TRTC-API-Example.SetAudioQuality.userId")
        
        return lable
    }()
    
    let audioQualityLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        lable.text = Localize("TRTC-API-Example.SetAudioQuality.chooseVolume")
        
        return lable
    }()
    
    let audioVolumeLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.SetBGM.bgmChanger")
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let volumeLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let volumeSlider : UISlider={
        let slider = UISlider(frame: .zero)
        slider.isContinuous = true
        slider.maximumValue = 1
        return slider
    }()
  
  
    let localVideoView:UIView={
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0
        view.tag = 200
        
        return view
    }()
    
    
    let roomIdTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .gray
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        filed.isEnabled = false
        return filed
    }()
    
    let userIdTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(999999 - 100000 + 1) + 100000)
        filed.textColor = .gray
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        filed.isEnabled = false
        return filed
    }()
    
    let audioSpeechButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioQuality.qualitySpeech"), for: .normal)
        return button
    }()
    
    let audioDefaultButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle(Localize("TRTC-API-Example.SetAudioQuality.qualityDefalut"), for: .normal)
        return button
    }()
    
    let audioMusicButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle(Localize("TRTC-API-Example.SetAudioQuality.qualityMusic"), for: .normal)
        return button
    }()
    
    let startPublisherButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.SetAudioQuality.start"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.SetAudioQuality.stop"), for: .selected)
        return button
    }()
    
}

extension SetAudioQualityViewController{
    
    private func setupDefaultUIConfig(){
        view.addSubview(roomIdLabel)
        view.addSubview(userIdLabel)
        view.addSubview(audioQualityLabel)
        view.addSubview(audioVolumeLabel)
        view.addSubview(roomIdLabel)
        view.addSubview(volumeLabel)
        
        view.addSubview(roomIdTextField)
        view.addSubview(userIdTextField)
        view.addSubview(audioSpeechButton)
        view.addSubview(audioDefaultButton)
        view.addSubview(audioMusicButton)
        view.addSubview(startPublisherButton)
        view.addSubview(volumeSlider)
        view.addSubview(localVideoView)
        
        if let text = volumeLabel.text{
            volumeSlider.value = 0
        }
    }
    
    private func activateConstraints(){
        
        audioQualityLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.left.equalTo(20)
            make.bottom.equalTo(view.snp.bottom).offset(-150)
        }
        
        audioVolumeLabel.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(25)
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(audioQualityLabel)
        }
        
        audioDefaultButton.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width - 210)/3)
            make.height.equalTo(audioQualityLabel)
            make.left.equalTo(audioQualityLabel)
            make.top.equalTo(audioQualityLabel.snp.bottom).offset(5)
        }
        
        audioSpeechButton.snp.makeConstraints { make in
            make.width.equalTo(audioDefaultButton)
            make.height.equalTo(audioDefaultButton)
            make.left.equalTo(audioDefaultButton.snp.right).offset(5)
            make.top.equalTo(audioDefaultButton)
        }
        
        audioMusicButton.snp.makeConstraints { make in
            make.width.equalTo(audioSpeechButton)
            make.height.equalTo(audioSpeechButton)
            make.top.equalTo(audioSpeechButton)
            make.left.equalTo(audioSpeechButton.snp.right).offset(5)
        }
        
        
        volumeSlider.snp.makeConstraints { make in
            make.height.equalTo(audioVolumeLabel)
            make.top.equalTo(audioVolumeLabel.snp.bottom).offset(5)
            make.left.equalTo(audioVolumeLabel)
            make.right.equalTo(audioVolumeLabel.snp.right).offset(-15)
        }
        
        volumeLabel.snp.makeConstraints { make in
            make.height.equalTo(volumeSlider)
            make.top.equalTo(volumeSlider)
            make.left.equalTo(volumeSlider.snp.right).offset(2)
            make.right.equalTo(audioVolumeLabel.snp.right)
        }
        
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width - 80)/3)
            make.height.equalTo(audioQualityLabel)
            make.top.equalTo(audioDefaultButton.snp.bottom).offset(5)
            make.left.equalTo(audioDefaultButton)
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
            make.top.equalTo(roomIdLabel.snp.bottom).offset(5)
            make.left.equalTo(roomIdLabel)
        }
        userIdTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIdTextField)
            make.height.equalTo(roomIdTextField)
            make.top.equalTo(roomIdTextField)
            make.left.equalTo(roomIdTextField.snp.right).offset(20)
        }
        
        startPublisherButton.snp.makeConstraints { make in
            make.width.equalTo(userIdTextField)
            make.height.equalTo(userIdTextField)
            make.top.equalTo(userIdTextField)
            make.left.equalTo(userIdTextField.snp.right).offset(20)
        }
        
    }
    private func bindInteraction(){
        audioSpeechButton.addTarget(self, action: #selector(onSpeechButtonClick), for: .touchUpInside)
        audioDefaultButton.addTarget(self, action: #selector(onDefaultButtonClick), for: .touchUpInside)
        audioMusicButton.addTarget(self, action: #selector(onMusicButtonClick), for: .touchUpInside)
        startPublisherButton.addTarget(self, action: #selector(onStartButtonClick), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(onVolumeChanged), for: .valueChanged)
        }
}
extension SetAudioQualityViewController{
    @objc private func onSpeechButtonClick(){
        audioQuality = .speech
        if running ,let audioQuality = audioQuality{
            trtcCloud.startLocalAudio(audioQuality )
        }
        audioSpeechButton.backgroundColor = .green
        audioDefaultButton.backgroundColor = .gray
        audioMusicButton.backgroundColor = .gray
    }
    
    @objc private func onDefaultButtonClick(){
        audioQuality = .default
        if running ,let audioQuality = audioQuality{
            trtcCloud.startLocalAudio(audioQuality )
        }
        audioSpeechButton.backgroundColor = .gray
        audioDefaultButton.backgroundColor = .green
        audioMusicButton.backgroundColor = .gray
        
    }
    
    @objc private func onMusicButtonClick(){
        audioQuality = .music
        if running ,let audioQuality = audioQuality{
            trtcCloud.startLocalAudio(audioQuality )
        }
        audioSpeechButton.backgroundColor = .gray
        audioDefaultButton.backgroundColor = .gray
        audioMusicButton.backgroundColor = .green
        
    }
    
    @objc private func onVolumeChanged(){
       
        volumeLabel.text = String(Int(volumeSlider.value * 100))
        
        trtcCloud.setAudioCaptureVolume(Int(UInt32(volumeSlider.value)))
        
        
    }
    
    @objc private func onStartButtonClick(){
        if startPublisherButton.isSelected{
            trtcCloud.exitRoom()
            destroyTRTCCloud()
        }else{
            title = Localize("TRTC-API-Example.SetAudioQuality.Title").appending(roomIdTextField.text ?? "")
            setupTRTCCloud()
        }
        startPublisherButton.isSelected = !startPublisherButton.isSelected
    }
 
    
}

extension SetAudioQualityViewController{
    
    func destroyTRTCCloud(){
        running = false
        TRTCCloud.destroySharedIntance()
        trtcCloud.exitRoom()
    }
    
    func dealloc(){
        destroyTRTCCloud()
        removeKeyboardObserver()
    }
    
    func setupTRTCCloud(){
        running = true
        trtcCloud.startLocalPreview(true, view: view)
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32((roomIdTextField.text as! NSString).intValue)
        params.userId = userIdTextField.text ?? ""
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId ?? "") as String
        
        trtcCloud.enterRoom(params, appScene: .audioCall)
        
        let encParams = TRTCVideoEncParam()
        encParams.videoResolution = ._640_360
        encParams.videoBitrate = 550
        encParams.videoFps = 15
        
        trtcCloud.setVideoEncoderParam(encParams)
        trtcCloud.setAudioCaptureVolume(Int(volumeSlider.value))
        if let audioQuality = audioQuality{
            trtcCloud.startLocalAudio(audioQuality)
        }
    }
    
    
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti:NSNotification){
        let animationDuration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        let keyboardBounds = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        UIView.animate(withDuration: animationDuration as! TimeInterval) { [self] in
            self.bottomConstraint.constant = (keyboardBounds as! CGRect).size.height
        }
    }
    
    @objc func keyboardWillHide(_ noti:NSNotification){
        let animationDuration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        
        UIView.animate(withDuration:animationDuration as! TimeInterval) { [self] in
            self.bottomConstraint.constant = 25
        }
    }
    
}

extension SetAudioQualityViewController:UITextFieldDelegate{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userIdTextField.resignFirstResponder()
        return roomIdTextField.resignFirstResponder()
    }
}

extension SetAudioQualityViewController:TRTCCloudDelegate{
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        let index = remoteUidSet.index(of: userId)
        if available{
            if index != NSNotFound{
                return
            }
        }else{
            trtcCloud.stopRemoteView(userId, streamType: .small)
            remoteUidSet.remove(userId)
        }
        refreshRemoteVideoViews()
    }
    
    func refreshRemoteVideoViews(){
        var index = 0
        for userid in remoteUidSet{
            if index >= maxRemoteUserNum{
                return
            }
            remoteViewArr[index].isHidden = false
            trtcCloud.startRemoteView(userid as! String, streamType: .small, view: remoteViewArr[index])
            index = index + 1
        }
    }
    
   
}





