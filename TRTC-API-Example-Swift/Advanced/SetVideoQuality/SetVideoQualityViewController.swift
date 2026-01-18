//
//  SetVideoQualityViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_TRTC


/*
 Setting Video Quality
  TRTC Video Quality Setting
  This document shows how to integrate the video quality setting feature.
  1. Set resolution: trtcCloud.setVideoEncoderParam(videoEncParam)
  2. Set bitrate: trtcCloud.setVideoEncoderParam(videoEncParam)
  3. Set frame rate: trtcCloud.setVideoEncoderParam(videoEncParam)
  Documentation: https://cloud.tencent.com/document/product/647/32236
 */

class BitrateRange {
    var minBitrate: UInt32 = 0
    var maxBitrate: UInt32 = 0
    var defaultBitrate: UInt32 = 0
    init(minB: UInt32, maxB: UInt32, defaultB: UInt32) {
        minBitrate = minB
        maxBitrate = maxB
        defaultBitrate = defaultB
    }
}

class SetVideoQualityViewController: UIViewController {
    
    let maxRemoteUserNum = 6
    let trtcCloud = TRTCCloud.sharedInstance()
    let videoEncParam = TRTCVideoEncParam()
    var videoResolution = TRTCVideoResolution._960_540
    
    lazy var remoteUserIdSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
    
    let bitrateDic: [TRTCVideoResolution: BitrateRange] = {
        var dic = [TRTCVideoResolution: BitrateRange]()
        dic[TRTCVideoResolution._640_360] = BitrateRange(minB: 200, maxB: 1_000, defaultB: 800)
        dic[TRTCVideoResolution._960_540] = BitrateRange(minB: 400, maxB: 1_600, defaultB: 900)
        dic[TRTCVideoResolution._1280_720] = BitrateRange(minB: 500, maxB: 2_000, defaultB: 1_250)
        dic[TRTCVideoResolution._1920_1080] = BitrateRange(minB: 800, maxB: 3_000, defaultB: 1_900)
        return dic
    }()
    
    let roomIdLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetVideoQuality.roomId")
        lable.backgroundColor = .clear
        return lable
    }()
    
    let userIdLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.backgroundColor = .clear
        lable.text = Localize("TRTC-API-Example.SetVideoQuality.userId")
        return lable
    }()
    
    let chooseBitrateLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.backgroundColor = .clear
        lable.text = Localize("TRTC-API-Example.SetVideoQuality.chooseBitrate")
        return lable
    }()
    
    let chooseFpsLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.backgroundColor = .clear
        lable.text = Localize("TRTC-API-Example.SetVideoQuality.chooseFps")
        return lable
    }()
    
    let chooseResolutionLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SetVideoQuality.chooseResolution")
        lable.backgroundColor = .clear
        return lable
    }()
    
    let fpsSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.isContinuous = true
        slider.maximumValue = 24
        slider.minimumValue = 10
        slider.value = 15
        return slider
    }()
    
    let bitrateSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.isContinuous = true
        return slider
    }()
    
    let bitrateLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.font = .systemFont(ofSize: 15)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.backgroundColor = .clear
        return lable
    }()
    
    let fpsLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.font = .systemFont(ofSize: 15)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.backgroundColor = .clear
        return lable
    }()
    
    let leftRemoteViewA: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    let leftRemoteViewB: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    let leftRemoteViewC: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    let rightRemoteViewA: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    let rightRemoteViewB: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    let rightRemoteViewC: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    lazy var remoteViewArr: [UIView] = {
        return [leftRemoteViewA,leftRemoteViewB,leftRemoteViewC,rightRemoteViewA,rightRemoteViewB,rightRemoteViewC]
    }()
    
    let roomIDTextField: UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random() % (9_999_999 - 1_000_000 + 1) + 1_000_000)
        filed.textColor = .black
        filed.backgroundColor = .white
        return filed
    }()
    
    let userIDTextField: UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random() % (9_999_999 - 1_000_000 + 1) + 1_000_000)
        filed.textColor = .black
        filed.backgroundColor = .white
        return filed
    }()
    
    let startPushButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle(Localize("TRTC-API-Example.SetVideoQuality.start"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.SetVideoQuality.stop"), for: .selected)
        return button
    }()
    
    let video360PButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle("360P", for: .normal)
        return button
    }()
    
    let video540PButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle("540P", for: .normal)
        return button
    }()
    
    let video720PButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle("720P", for: .normal)
        return button
    }()
    
    let video1080PButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle("1080P", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        trtcCloud.delegate = self
        roomIDTextField.delegate = self
        userIDTextField.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        refreshBitrateSlider()
        addKeyboardObserver()
    }
    
    func setupTRTCCloud() {
        trtcCloud.startLocalPreview(true, view: view)
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        guard let roomId = roomIDTextField.text else {
            return
        }
        params.strRoomId = roomId
        guard let userId = userIDTextField.text else {
            return
        }
        params.userId = userId
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: userId) as String
        params.role = .anchor
        trtcCloud.enterRoom(params, appScene: .audioCall)
        videoEncParam.videoResolution = videoResolution
        videoEncParam.videoBitrate = Int32(bitrateSlider.value)
        videoEncParam.videoFps = Int32(fpsSlider.value)
        trtcCloud.setVideoEncoderParam(videoEncParam)
    }
    
    func destroyTRTCCloud() {
        TRTCCloud.destroySharedIntance()
        removeKeyboardObserver()
    }
    
    func refreshBitrateSlider() {
        guard let bitrateRange = bitrateDic[videoResolution] else {
            return
        }
        bitrateSlider.maximumValue = Float(bitrateRange.maxBitrate)
        bitrateSlider.minimumValue = Float(bitrateRange.minBitrate)
        bitrateSlider.value = Float(bitrateRange.defaultBitrate)
        onBitrateChanged(bitrateSlider)
    }
    
    func refreshEncParam() {
        videoEncParam.videoResolution = videoResolution
        videoEncParam.videoBitrate = Int32(bitrateSlider.value)
        videoEncParam.videoFps = Int32(fpsSlider.value)
        trtcCloud.setVideoEncoderParam(videoEncParam)
        
    }
    
    deinit {
        destroyTRTCCloud()
        removeKeyboardObserver()
    }
    
}

extension SetVideoQualityViewController {
    
    private func setupDefaultUIConfig() {
        view.addSubview(startPushButton)
        view.addSubview(video360PButton)
        view.addSubview(video540PButton)
        view.addSubview(video720PButton)
        view.addSubview(video1080PButton)
        view.addSubview(roomIdLabel)
        view.addSubview(bitrateSlider)
        view.addSubview(fpsSlider)
        
        view.addSubview(bitrateLabel)
        view.addSubview(fpsLabel)
        view.addSubview(userIdLabel)
        view.addSubview(chooseBitrateLabel)
        view.addSubview(chooseFpsLabel)
        view.addSubview(chooseResolutionLabel)
        
        view.addSubview(leftRemoteViewA)
        view.addSubview(leftRemoteViewB)
        view.addSubview(leftRemoteViewC)
        view.addSubview(rightRemoteViewA)
        view.addSubview(rightRemoteViewB)
        view.addSubview(rightRemoteViewC)
        
        view .addSubview(roomIDTextField)
        view .addSubview(userIDTextField)
        
        bitrateLabel.text = String(Int(bitrateSlider.value))+"kbps"
        fpsLabel.text = String(Int(fpsSlider.value))+"fps"
        
    }
    
    private func activateConstraints() {
        
        leftRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(160)
            make.left.equalTo(10)
            make.top.equalTo(rightRemoteViewA.snp.top)
        }
        
        rightRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.right.equalTo(-10)
            make.top.equalTo(80)
        }

        leftRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.top.equalTo(rightRemoteViewB)
            make.left.equalTo(leftRemoteViewA)
        }

        rightRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteViewB)
            make.top.equalTo(rightRemoteViewA.snp.bottom).offset(16)
            make.left.equalTo(rightRemoteViewA.snp.left)
        }

        leftRemoteViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteViewB)
            make.top.equalTo(rightRemoteViewC)
            make.left.equalTo(leftRemoteViewB)
        }

        rightRemoteViewC.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewC)
            make.height.equalTo(leftRemoteViewC)
            make.top.equalTo(rightRemoteViewB.snp.bottom).offset(16)
            make.left.equalTo(rightRemoteViewB)
        }

        chooseResolutionLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width - 60)/3)
            make.height.equalTo(25)
            make.top.equalTo(view.snp.bottom).offset(-250)
            make.left.equalTo(20)
        }

        video360PButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
            make.top.equalTo(chooseResolutionLabel.snp.bottom).offset(10)
            make.left.equalTo(chooseResolutionLabel)
        }

        video540PButton.snp.makeConstraints { make in
            make.width.equalTo(video360PButton)
            make.height.equalTo(video360PButton)
            make.top.equalTo(video360PButton)
            make.left.equalTo(video360PButton.snp.right).offset(10)
        }

        video720PButton.snp.makeConstraints { make in
            make.width.equalTo(video360PButton)
            make.height.equalTo(video360PButton)
            make.top.equalTo(video540PButton)
            make.left.equalTo(video540PButton.snp.right).offset(10)
        }
        
        video1080PButton.snp.makeConstraints { make in
            make.width.equalTo(video360PButton)
            make.height.equalTo(video360PButton)
            make.top.equalTo(video360PButton)
            make.left.equalTo(video720PButton.snp.right).offset(10)
        }

        chooseBitrateLabel.snp.makeConstraints { make in
            make.width.equalTo(chooseResolutionLabel)
            make.height.equalTo(chooseResolutionLabel)
            make.top.equalTo(video360PButton.snp.bottom).offset(10)
            make.left.equalTo(video360PButton)
        }
        
        chooseFpsLabel.snp.makeConstraints { make in
            make.width.equalTo(chooseResolutionLabel)
            make.height.equalTo(chooseResolutionLabel)
            make.top.equalTo(chooseBitrateLabel)
            make.left.equalTo(fpsSlider)
        }

        bitrateSlider.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(20)
            make.top.equalTo(chooseBitrateLabel.snp.bottom).offset(10)
            make.left.equalTo(chooseBitrateLabel)
        }
        
        bitrateLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(23)
            make.top.equalTo(bitrateSlider)
            make.left.equalTo(bitrateSlider.snp.right).offset(10)
        }
        
        fpsSlider.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(20)
            make.top.equalTo(bitrateSlider)
            make.left.equalTo(bitrateLabel.snp.right).offset(5)
        }
        
        fpsLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(23)
            make.top.equalTo(fpsSlider)
            make.left.equalTo(fpsSlider.snp.right).offset(10)
        }
        
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(25)
            make.top.equalTo(bitrateLabel.snp.bottom).offset(10)
            make.left.equalTo(chooseBitrateLabel)
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
        startPushButton.addTarget(self, action: #selector(onStartButtonClick(sender: )), for: .touchUpInside)
        video360PButton.addTarget(self, action: #selector(onVideo360PClick(sender: )), for: .touchUpInside)
        video540PButton.addTarget(self, action: #selector(onVideo540PClick(sender: )), for: .touchUpInside)
        video720PButton.addTarget(self, action: #selector(onVideo720PClick(sender: )), for: .touchUpInside)
        video1080PButton.addTarget(self, action: #selector(onVideo1080PClick(sender: )), for: .touchUpInside)
        bitrateSlider.addTarget(self, action: #selector(onBitrateChanged), for: .valueChanged)
        fpsSlider.addTarget(self, action: #selector(onFpsChanged), for: .valueChanged)
        }
}
extension SetVideoQualityViewController {
    
    @objc private func onVideo360PClick(sender: UIButton) {
        videoResolution = TRTCVideoResolution._640_360
        video360PButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        video540PButton.backgroundColor = .gray
        video720PButton.backgroundColor = .gray
        video1080PButton.backgroundColor = .gray
        refreshEncParam()
        refreshBitrateSlider()
    }
    
    @objc private func onVideo540PClick(sender: UIButton) {
        videoResolution = TRTCVideoResolution._960_540
        video360PButton.backgroundColor = .gray
        video540PButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        video720PButton.backgroundColor = .gray
        video1080PButton.backgroundColor = .gray
        refreshEncParam()
        refreshBitrateSlider()
    }
    
    @objc private func onVideo720PClick(sender: UIButton) {
        videoResolution = TRTCVideoResolution._1280_720
        video360PButton.backgroundColor = .gray
        video540PButton.backgroundColor = .gray
        video720PButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        video1080PButton.backgroundColor = .gray
        refreshEncParam()
        refreshBitrateSlider()
    }
    
    @objc private func onVideo1080PClick(sender: UIButton) {
        videoResolution = TRTCVideoResolution._1920_1080
        video360PButton.backgroundColor = .gray
        video540PButton.backgroundColor = .gray
        video720PButton.backgroundColor = .gray
        video1080PButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        refreshEncParam()
        refreshBitrateSlider()
    }

    @objc private func onStartButtonClick(sender: UIButton) {
        if sender.isSelected {
            title = Localize("TRTC-API-Example.SetVideoQuality.Title")
            trtcCloud.stopLocalPreview()
            trtcCloud.exitRoom()
            destroyTRTCCloud()
        } else {
            guard let text = roomIDTextField.text else {
                return
            }
            title = Localize("TRTC-API-Example.SetVideoQuality.Title").appendingFormat(text)
            setupTRTCCloud()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc private func onBitrateChanged(_ bitrateSlider: UISlider) {
        bitrateLabel.text = String(Int(bitrateSlider.value))+" kbps"
        refreshEncParam()
    }
    
    @objc private func onFpsChanged(_ fpsSlider: UISlider) {
        let fpsValue = fpsSlider.value
        fpsLabel.text = String(Int(fpsValue))+" fps"
        refreshEncParam()
    }
    
}


extension SetVideoQualityViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ noti: NSNotification) {
        let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        guard let frame = keyboardFrame as? CGRect else {
            return
        }
        let keyboardY = (frame).origin.y
        UIView.animate(withDuration: 1.0) {
            self.view.transform = CGAffineTransform(translationX: 0, y: keyboardY - self.view.frame.size.height)
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.view.transform =  .identity
        }
    }
}

extension SetVideoQualityViewController: UITextFieldDelegate {
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

extension SetVideoQualityViewController: TRTCCloudDelegate {

    func onUserVideoAvailable(_ userId: String, available: Bool) {
        let index = remoteUserIdSet.index(of: userId)
        if available {
            if index != NSNotFound {
                return
            }
            remoteUserIdSet.add(userId)
        }
        else {
            trtcCloud.stopRemoteView(userId, streamType: .small)
            remoteUserIdSet.remove(userId)
        }
        refreshRemoteVideoViews()
        
    }
    
    func refreshRemoteVideoViews() {
        var index = 0
        if remoteUserIdSet.count == 0 {
            return
        }
        for uid in remoteUserIdSet {
            if index >= maxRemoteUserNum {
                return
            }
            remoteViewArr[index].isHidden = false
            guard let userId = uid as? String else {
                return
            }
            trtcCloud.startRemoteView(userId, streamType: .small, view: remoteViewArr[index])
            index = index + 1
        }
    }
}

extension SetVideoQualityViewController {
    func initWithMinBitrate(_ minBitrate: UInt32 ,_ maxBitRate: UInt32, _ defaultBitrate: UInt32) -> BitrateRange {
        return BitrateRange(minB: minBitrate, maxB: maxBitRate, defaultB: defaultBitrate)
    }
}
