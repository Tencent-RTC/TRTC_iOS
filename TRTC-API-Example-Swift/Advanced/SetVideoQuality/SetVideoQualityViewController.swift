////
////  SetVideoQualityViewController.swift
////  TRTC-API-Example-Swift
////
////  Created by 唐佳宁 on 2022/7/1.
////  Copyright © 2022 Tencent. All rights reserved.
////
///*
//设置画面质量功能
// TRTC APP 设置画面质量功能
// 本文件展示如何集成设置画面质量功能
// 1、设置分辨率 API: [self.trtcCloud setVideoEncoderParam:self.videoEncParam];
// 2、设置码率 API: [self.trtcCloud setVideoEncoderParam:self.videoEncParam];
// 3、设置帧率 API: [self.trtcCloud setVideoEncoderParam:self.videoEncParam];
// 参考文档：https://cloud.tencent.com/document/product/647/32236
// */
//
///*
// Setting Video Quality
//  TRTC Video Quality Setting
//  This document shows how to integrate the video quality setting feature.
//  1. Set resolution: [self.trtcCloud setVideoEncoderParam:self.videoEncParam]
//  2. Set bitrate: [self.trtcCloud setVideoEncoderParam:self.videoEncParam]
//  3. Set frame rate: [self.trtcCloud setVideoEncoderParam:self.videoEncParam]
//  Documentation: https://cloud.tencent.com/document/product/647/32236
// */
//
//import Foundation
//import UIKit
//import TXLiteAVSDK_TRTC
//
//class BitrateRange : NSObject{
//    var minBitrate : UInt32  = 0
//    var maxBitrate : UInt32  = 0
//    var defaultBitrate : UInt32  = 0
//
//    func  initWithMinBitrate(minBitrate:UInt32 , maxBitrate:UInt32 , defaultBitrate:UInt32)->Self{
//        let bitrateRange = BitrateRange()
//        bitrateRange.minBitrate = minBitrate
//        bitrateRange.maxBitrate = maxBitrate
//        bitrateRange.defaultBitrate = defaultBitrate
//
//    }
//
//}
//
//class SetVideoQualityViewController : UIViewController, TRTCCloudDelegate{
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        trtcCloud.delegate = self
//        roomIdTextField.delegate = self
//        userIdTextField.delegate = self
//        setupDefaultUIConfig()
//        activateConstraints()
//        bindInteraction()
//        addKeyboardObserver()
//
//    }
//
////    private func startPushStream(){
////        title = LocalizeReplace("TRTC-API-Example.SetAudioEffect.Title",roomIDTextField.text ?? "")
////        trtcCloud.startLocalPreview(true, view: view)
////        let params = TRTCParams()
////        params.sdkAppId = UInt32(SDKAPPID)
////        params.roomId = UInt32((roomIDTextField.text! as NSString).integerValue)
////        params.userId = userIDTextField.text ?? ""
////        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userIDTextField.text ?? "") as String
////        params.role = .anchor
////
////        trtcCloud.delegate = self
////        trtcCloud.enterRoom(params, appScene: .voiceChatRoom)
////        trtcCloud.startLocalAudio(.music)
////
////        let encParams =  TRTCVideoEncParam()
////        encParams.videoResolution = ._960_540
////        encParams.videoFps = 24
////        encParams.resMode = .portrait
////
////        trtcCloud.setVideoEncoderParam(encParams)
////    }
////     private func stopPushStream(){
////        trtcCloud.stopLocalPreview()
////        trtcCloud.stopLocalAudio()
////        trtcCloud.exitRoom()
////         leftRemoteViewA.alpha = 0
////         if remoteUserIdSet.count == 0{
////             trtcCloud.stopRemoteView(userIDTextField.text ?? "", streamType: .small)
////             return
////         }
////        for  i in 0...remoteUserIdSet.count{
////            let remoteView = view.viewWithTag(i+200)
////            let remoteLable = view.viewWithTag(i+300) as! UILabel
////            remoteView?.alpha = 0
////            remoteLable.text = ""
////            trtcCloud.stopRemoteView(remoteUserIdSet[i] as! String, streamType: .small)
////        }
////        remoteUserIdSet.removeAllObjects()
////    }
//
//    let remoteViewArr = NSArray()
//    let bottomConstraint = NSLayoutConstraint()
//    let trtcCloud = TRTCCloud.sharedInstance()
//    let videoEncParam = TRTCVideoEncParam()
//    var videoResolution = TRTCVideoResolution(rawValue: 0)
//    var remoteUidSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
//    var bitrateDic = NSMutableDictionary()
//
//    let roomIdLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.text = Localize("TRTC-API-Example.SetBGM.roomId")
//        lable.backgroundColor = .gray
//        return lable
//    }()
//
//    let userIdLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
//        lable.text = Localize("TRTC-API-Example.SetBGM.userId")
//
//        return lable
//    }()
//
//    let chooseBitrateLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
//        lable.text = Localize("TRTC-API-Example.SetBGM.setBgmVolume")
//
//        return lable
//    }()
//
//    let chooseFpsLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.text = Localize("TRTC-API-Example.SetBGM.bgmChanger")
//        lable.backgroundColor = .gray
//        return lable
//    }()
//
//    let chooseResolutionLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.text = Localize("TRTC-API-Example.SetBGM.bgmChanger")
//        lable.backgroundColor = .gray
//        return lable
//    }()
//
//    let bgmVolumeNumberLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.text = Localize("TRTC-API-Example.SetBGM.bgmChanger")
//        lable.backgroundColor = .gray
//        return lable
//    }()
//
//    let bitrateSlider : UISlider={
//        let slider = UISlider(frame: .zero)
//        slider.isContinuous = true
//        slider.maximumValue = 1.5
//        return slider
//    }()
//
//    let fpsSlider : UISlider={
//        let slider = UISlider(frame: .zero)
//        slider.isContinuous = true
//        slider.maximumValue = 1.5
//        return slider
//    }()
//
//    let bitrateLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
//        return lable
//    }()
//
//    let fpsLabel:UILabel={
//        let lable = UILabel(frame: .zero)
//        lable.textColor = .white
//        lable.adjustsFontSizeToFitWidth = true
//        lable.tag = 300
//        lable.backgroundColor = .gray
//        return lable
//    }()
//
//
//    let roomIdTextField : UITextField={
//        let filed = UITextField(frame: .zero)
//        filed.keyboardAppearance = .default
//        filed.text = "1356732"
//        filed.textColor = .black
//        filed.backgroundColor = .white
//        filed.returnKeyType = .done
//        return filed
//    }()
//
//    let userIdTextField : UITextField={
//        let filed = UITextField(frame: .zero)
//        filed.keyboardAppearance = .default
//        filed.text = "1356732"
//        filed.textColor = .black
//        filed.backgroundColor = .white
//        filed.returnKeyType = .done
//        return filed
//    }()
//
//    let video360PButton : UIButton={
//        let button = UIButton(frame: .zero)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = .green
//        button.setTitle(Localize("TRTC-API-Example.SetBGM.startPush"), for: .normal)
//        button.setTitle(Localize("TRTC-API-Example.SetBGM.stopPush"), for: .selected)
//        return button
//    }()
//
//    let video540PButton : UIButton={
//        let button = UIButton(frame: .zero)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = .green
//        button.setTitle(Localize("TRTC-API-Example.SetBGM.bgm1"), for: .normal)
//        return button
//    }()
//
//    let video720PButton : UIButton={
//        let button = UIButton(frame: .zero)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = .green
//        button.setTitle(Localize("TRTC-API-Example.SetBGM.bgm2"), for: .normal)
//        return button
//    }()
//
//    let video1080PButton : UIButton={
//        let button = UIButton(frame: .zero)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = .green
//        button.setTitle(Localize("TRTC-API-Example.SetBGM.bgm3"), for: .normal)
//        return button
//    }()
//
//    let startPublisherButton : UIButton={
//        let button = UIButton(frame: .zero)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = .green
//        button.setTitle(Localize("TRTC-API-Example.SetBGM.bgm3"), for: .normal)
//        return button
//    }()
//
//    let localVideoView : UIView={
//        let view = UIView(frame: .zero)
//
//        return view
//    }()
//
//}
//
//extension SetVideoQualityViewController{
//    private func setupDefaultUIConfig(){
//        view.addSubview(roomIdLabel)
//        view.addSubview(userIdLabel)
//        view.addSubview(chooseBitrateLabel)
//        view.addSubview(chooseFpsLabel)
//        view.addSubview(chooseResolutionLabel)
//        view.addSubview(bitrateLabel)
//
//        view.addSubview(fpsLabel)
//        view.addSubview(roomIdTextField)
//        view.addSubview(userIdTextField)
//        view.addSubview(bgmVolumeNumberLabel)
//
//        view.addSubview(video360PButton)
//        view.addSubview(video540PButton)
//        view.addSubview(video720PButton)
//        view.addSubview(video1080PButton)
//        view .addSubview(startPublisherButton)
//        view .addSubview(bitrateSlider)
//        view .addSubview(fpsSlider)
//        view .addSubview(localVideoView)
//    }
//
//    private func activateConstraints(){
//
//        chooseResolutionLabel.snp.makeConstraints { make in
//            make.width.equalTo(80)
//            make.height.equalTo(25)
//            make.left.equalTo(20)
//            make.bottom.equalTo(view.snp.bottom).offset(-200)
//        }
//
//        video360PButton.snp.makeConstraints { make in
//            make.width.equalTo(chooseResolutionLabel)
//            make.height.equalTo(chooseResolutionLabel)
//            make.left.equalTo(chooseResolutionLabel)
//            make.top.equalTo(chooseResolutionLabel.snp.bottom).offset(5)
//        }
//
//        video540PButton.snp.makeConstraints { make in
//            make.width.equalTo(video360PButton)
//            make.height.equalTo(video360PButton)
//            make.left.equalTo(video360PButton.snp.right).offset(5)
//            make.top.equalTo(video360PButton)
//        }
//
//        video720PButton.snp.makeConstraints { make in
//            make.width.equalTo(video540PButton)
//            make.height.equalTo(video540PButton)
//            make.left.equalTo(video540PButton.snp.right).offset(5)
//            make.top.equalTo(video540PButton)
//        }
//
//        video1080PButton.snp.makeConstraints { make in
//            make.width.equalTo(video720PButton)
//            make.height.equalTo(video720PButton)
//            make.top.equalTo(video720PButton.snp.bottom).offset(5)
//            make.left.equalTo(video720PButton)
//        }
//
//
//        chooseBitrateLabel.snp.makeConstraints { make in
//            make.width.equalTo(chooseResolutionLabel)
//            make.height.equalTo(chooseResolutionLabel)
//            make.top.equalTo(video360PButton.snp.bottom).offset(5)
//            make.left.equalTo(video360PButton)
//        }
//
//        chooseFpsLabel.snp.makeConstraints { make in
//            make.width.equalTo(chooseBitrateLabel)
//            make.height.equalTo(chooseBitrateLabel)
//            make.top.equalTo(chooseBitrateLabel)
//            make.left.equalTo(chooseBitrateLabel.snp.right).offset(50)
//        }
//
//        bitrateSlider.snp.makeConstraints { make in
//            make.width.equalTo(100)
//            make.height.equalTo(30)
//            make.top.equalTo(chooseBitrateLabel.snp.bottom).offset(5)
//            make.left.equalTo(chooseBitrateLabel)
//        }
//
//        bitrateLabel.snp.makeConstraints { make in
//            make.width.equalTo(50)
//            make.height.equalTo(30)
//            make.top.equalTo(bitrateSlider)
//            make.left.equalTo(bitrateSlider.snp.right).offset(5)
//        }
//
//
//        fpsSlider.snp.makeConstraints { make in
//            make.width.equalTo(bitrateSlider)
//            make.height.equalTo(bitrateSlider)
//            make.top.equalTo(bitrateLabel)
//            make.left.equalTo(bitrateLabel.snp.right).offset(5)
//        }
//
//        roomIdLabel.snp.makeConstraints { make in
//            make.width.equalTo(chooseResolutionLabel)
//            make.height.equalTo(chooseResolutionLabel)
//            make.top.equalTo(bitrateSlider.snp.bottom).offset(5)
//            make.left.equalTo(bitrateSlider)
//        }
//
//        userIdLabel.snp.makeConstraints { make in
//            make.width.equalTo(chooseResolutionLabel)
//            make.height.equalTo(chooseResolutionLabel)
//            make.top.equalTo(roomIdLabel)
//            make.left.equalTo(roomIdLabel.snp.right).offset(40)
//        }
//
//        roomIdTextField.snp.makeConstraints { make in
//            make.width.equalTo(100)
//            make.height.equalTo(30)
//            make.top.equalTo(roomIdLabel.snp.bottom).offset(5)
//            make.left.equalTo(roomIdLabel)
//        }
//
//
//        userIdTextField.snp.makeConstraints { make in
//            make.width.equalTo(roomIdTextField)
//            make.height.equalTo(roomIdTextField)
//            make.top.equalTo(roomIdTextField)
//            make.left.equalTo(roomIdTextField.snp.right).offset(5)
//        }
//
//        startPublisherButton.snp.makeConstraints { make in
//            make.width.equalTo(userIdTextField)
//            make.height.equalTo(userIdTextField)
//            make.top.equalTo(userIdTextField)
//            make.left.equalTo(userIdTextField.snp.right).offset(5)
//        }
//
//
//    }
//    private func bindInteraction(){
//        video360PButton.addTarget(self, action: #selector(onVideo360PClick), for: .touchUpInside)
//        video540PButton.addTarget(self, action: #selector(onVideo540PClick), for: .touchUpInside)
//        video720PButton.addTarget(self, action: #selector(onVideo720PClick), for: .touchUpInside)
//        video1080PButton.addTarget(self, action: #selector(onVideo1080PClick), for: .touchUpInside)
//        startPublisherButton.addTarget(self, action: #selector(onStartButtonClick), for: .touchUpInside)
//        bitrateSlider.addTarget(self, action: #selector(onBitrateChanged), for: .valueChanged)
//        fpsSlider.addTarget(self, action: #selector(onFpsChanged), for: .valueChanged)
//        }
//}
//extension SetVideoQualityViewController{
//    @objc private func onVideo360PClick(){
//        videoResolution = ._640_360
//        video360PButton.backgroundColor = .green
//        video540PButton.backgroundColor = .gray
//        video720PButton.backgroundColor = .gray
//        video1080PButton.backgroundColor = .gray
//
//        refreshBitrateSlider()
//
//        [self refreshBitrateSlider];
//        [self refreshEncParam];
//
//
//    }
//
//    @objc private func clickBgmButtonB(){
//        if bgmParam.id > 0{
//            trtcCloud.getAudioEffectManager().stopPlayMusic(bgmParam.id)
//        }
//        let path = bgmURLArray[1]
//        bgmParam.id = 2234
//        bgmParam.path = path
//        bgmParam.publish = true
//        trtcCloud.getAudioEffectManager().startPlayMusic(bgmParam) { errCode in
//
//        } onProgress: { progressMs, durationMs in
//
//        } onComplete: { errCode in
//
//        }
//    }
//
//    @objc private func clickBgmButtonC(){
//        if bgmParam.id > 0{
//            trtcCloud.getAudioEffectManager().stopPlayMusic(bgmParam.id)
//        }
//        let path = bgmURLArray[2]
//        bgmParam.id = 3234
//        bgmParam.path = path
//        bgmParam.publish = true
//        trtcCloud.getAudioEffectManager().startPlayMusic(bgmParam) { errCode in
//
//        } onProgress: { progressMs, durationMs in
//
//        } onComplete: { errCode in
//
//        }
//    }
//
//    @objc private func clickStartPushButton(){
//        startPushButton.isSelected = !startPushButton.isSelected
//        if startPushButton.isSelected{
//            startPushStream()
//        }else{
//            stopPushStream()
//        }
//    }
//
//    @objc private func bgmVolumeSliderValueChange(){
//        let volume = bgmVolumeSlider.value
//        bgmVolumeNumberLabel.text = String(volume)
//        if bgmParam.id == 0{
//            return
//        }
//        trtcCloud.getAudioEffectManager().setMusicPlayoutVolume(bgmParam.id, volume: Int(volume))
//        trtcCloud.getAudioEffectManager().setMusicPublishVolume(bgmParam.id, volume: Int(volume))
//    }
//
//    @objc private func bgmSliderValueChange(){
//        let index =  Int(bgmVolumeSlider.value * 100)
//        bgmVolumeNumberLabel.text = String(index)
//        if bgmParam.id == 0{
//            return
//        }
//        trtcCloud.getAudioEffectManager().setMusicPublishVolume(bgmParam.id, volume: Int(index))
//        trtcCloud.getAudioEffectManager().setMusicPlayoutVolume(bgmParam.id, volume: Int(index))
//
//
//        BitrateRange *bitrateRange = [_bitrateDic objectForKey:[@(_videoResolution) stringValue]];
//
//        _bitrateSlider.maximumValue = bitrateRange.maxBitrate;
//        _bitrateSlider.minimumValue = bitrateRange.minBitrate;
//        _bitrateSlider.value = bitrateRange.defaultBitrate;
//
//        [self onBitrateChanged:_bitrateSlider];
//    }
//
//    func refreshBitrateSlider(){
//        let bitrateRange = bitrateDic.object(forKey: String(videoResolution)) as! BitrateRange
//        bitrateSlider.maximumValue = Float(bitrateRange.maxBitrate)
//        bitrateSlider.maximumValue = Float(bitrateRange.minBitrate)
//        bitrateSlider.value = Float(bitrateRange.defaultBitrate)
//        onBitrateChanged()
//    }
//
//}
//
//extension SetVideoQualityViewController{
//
//    func addKeyboardObserver(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    func removeKeyboardObserver(){
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    func dealloc(){
//        removeKeyboardObserver()
//        trtcCloud.stopLocalAudio()
//        trtcCloud.stopLocalPreview()
//        trtcCloud.exitRoom()
//        TRTCCloud.destroySharedIntance()
//    }
//
//    @objc func keyboardWillShow(_ noti:NSNotification){
//        let animationDuration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
//        let keyboardBounds = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
//        UIView.animate(withDuration: animationDuration as! TimeInterval) { [self] in
//            self.bottomConstraint.constant = (keyboardBounds as! CGRect).size.height
//        }
//    }
//
//    @objc func keyboardWillHide(_ noti:NSNotification){
//        let animationDuration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
//
//        UIView.animate(withDuration:animationDuration as! TimeInterval) { [self] in
//            self.bottomConstraint.constant = 25
//        }
//    }
//
//    func showRemoteUserViewWith(_ userId:String){
//        if remoteUserIdSet.count < maxRemoteUserNum{
//            let count = remoteUserIdSet.count
//            remoteUserIdSet.add(userId)
//            let view = view.viewWithTag(count + 200)
//            let lable = view?.viewWithTag(count + 300) as! UILabel
//            view?.alpha = 1
//            lable.text = LocalizeReplace("TRTC-API-Example.SendAndReceiveSEI.UserIdxx", userId)
//            trtcCloud.startRemoteView(userId, streamType: .small, view: view)
//
//        }
//    }
//
//    func hiddenRemoteUserViewWith(_ userId:String){
//        let viewTag = remoteUserIdSet.index(of: userId)
//        let view = view.viewWithTag(viewTag + 200)
//        let lable = view?.viewWithTag(viewTag + 300) as! UILabel
//        view?.alpha = 1
//        lable.text = ""
//        trtcCloud.stopRemoteView(userId, streamType: .small)
//        remoteUserIdSet.remove(userId)
//    }
//}
//
//extension SetVideoQualityViewController:UITextFieldDelegate{
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        userIDTextField.resignFirstResponder()
//        roomIDTextField.resignFirstResponder()
//    }
//
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        userIDTextField.resignFirstResponder()
//        return roomIDTextField.resignFirstResponder()
//    }
//}
//
//extension SetBGMViewController:TRTCCloudDelegate{
//    func onRemoteUserEnterRoom(_ userId: String) {
//        let index = remoteUserIdSet.index(of: userId)
//        if index == NSNotFound{
//            showRemoteUserViewWith(userId)
//        }
//    }
//
//    func onConnectOtherRoom(_ userId: String, errCode: TXLiteAVError, errMsg: String?) {
//        let index = remoteUserIdSet.index(of: userId)
//        if index != NSNotFound{
//            hiddenRemoteUserViewWith(userId)
//        }
//    }
//}
//
//
//
//
