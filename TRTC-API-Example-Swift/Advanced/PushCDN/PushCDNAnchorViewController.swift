//
//  PushCDNAnchorViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/7/13.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_TRTC

/*
 CDN发布功能 - 主播端
 TRTC APP CDN发布功能
 本文件展示如何集成CDN发布功能
 1、进入TRTC房间。 API: trtcCloud.enterRoom(params, appScene: .LIVE)
 2、多云端混流。 API: trtcCloud.setMix(transcodingConfig)
 参考文档：https://cloud.tencent.com/document/product/647/16827
 */
/*
 CDN Publishing - Anchor
 TRTC CDN Publishing
 This document shows how to integrate the CDN publishing feature.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Mix multiple streams on the cloud: trtcCloud.setMix(transcodingConfig)
 Documentation: https://cloud.tencent.com/document/product/647/16827
 */

enum ShowMode: String {
    case manual
    case leftAndRight
    case pictureAndPicture
}

let RemoteUserMaxNum: Int = 3

class PushCDNAnchorViewController: UIViewController {
    let audienceViewA = UIView()
    let audienceViewB = UIView()
    let audienceViewC = UIView()
    
    lazy var remoteViewArr: [UIView] = {
        return [audienceViewA, audienceViewB, audienceViewC]
    }()
    
    let roomNumberLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.PushCDNAnchor.roomId")
        lable.backgroundColor = .clear
        return lable
    }()
    
    let streamIDLabel: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.backgroundColor = .clear
        lable.text = Localize("TRTC-API-Example.PushCDNAnchor.StreamId")
        
        return lable
    }()
    
    let streamURLTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 0.5
        textView.backgroundColor = .gray
        textView.alpha = 0
        return textView
    }()
    
    let roomIDTextField: UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random() % (9_999_999 - 1_000_000 + 1) + 1_000_000)
        filed.textColor = .black
        filed.backgroundColor = .white
        return filed
    }()
    
    let streamIDTextField: UITextField = {
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
        button.setTitle(Localize("TRTC-API-Example.PushCDNAnchor.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.PushCDNAnchor.stopPush"), for: .selected)
        return button
    }()
    
    let moreMixStreamButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 17.0)
        button.backgroundColor = .gray
        return button
    }()
    
    let manualModeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(Localize("TRTC-API-Example.PushCDNAnchor.manualMode"), for: .normal)
        let normalImage = UIColor.gray.trans2Image(imageSize: CGSize(width: 14, height: 14))
        let selectImage = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1).trans2Image(imageSize: CGSize(width: 14, height: 14))
        button.setImage(normalImage, for: .normal)
        button.setImage(selectImage, for: .selected)
        return button
    }()
    
    let leftRightModeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        let normalImage = UIColor.gray.trans2Image(imageSize: CGSize(width: 14, height: 14))
        let selectImage = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1).trans2Image(imageSize: CGSize(width: 14, height: 14))
        button.setImage(normalImage, for: .normal)
        button.setImage(selectImage, for: .selected)
        button.setTitle(Localize("TRTC-API-Example.PushCDNAnchor.leftRightMode"), for: .normal)
        return button
    }()
    
    let pictureinPictureModeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        let normalImage = UIColor.gray.trans2Image(imageSize: CGSize(width: 14, height: 14))
        let selectImage = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1).trans2Image(imageSize: CGSize(width: 14, height: 14))
        button.setImage(normalImage, for: .normal)
        button.setImage(selectImage, for: .selected)
        button.setTitle(Localize("TRTC-API-Example.PushCDNAnchor.previewMode"), for: .normal)
        return button
    }()
    
    let trtcCloud = TRTCCloud.sharedInstance()
    let userID: String = String(arc4random() % (9_999_999 - 1_000_000 + 1) + 1_000_000)
    lazy var showMode: ShowMode = .manual
    lazy var remoteUserIdSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
    let transcodingConfig: TRTCTranscodingConfig = {
       let config = TRTCTranscodingConfig()
        config.videoWidth = 720
        config.videoHeight = 1_280
        config.videoBitrate = 1_500
        config.videoFramerate = 20
        config.videoGOP        = 2
        config.audioSampleRate = 48_000
        config.audioBitrate    = 64
        config.audioChannels   = 2
        config.appId   = Int32(CDNAPPID)
        config.bizId   = Int32(CDNBIZID)
        config.backgroundColor = 0x000000
        config.backgroundImage = nil
        return config
    }()
    lazy var mixUsers = [TRTCMixUser]()
    var isStartPush: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        trtcCloud.delegate = self
        roomIDTextField.delegate = self
        streamIDTextField.delegate = self
        constructViewHierarchy()
        activateConstraints()
        setShowMode(showMode: self.showMode)
        bindInteraction()
        addKeyboardObserver()
        checkMixConfigButtonEnable()
        navigationItem.leftBarButtonItem = nil
        
        guard let text = roomIDTextField.text else {
            return
        }
        navigationItem.title = "Room ID:" + text
    }
    
    func setShowMode(showMode: ShowMode) {
        self.showMode = showMode
        switch showMode {
        case .manual:
            manualModeButton.isSelected = true
            leftRightModeButton.isSelected = false
            pictureinPictureModeButton.isSelected = false
            break
        case .leftAndRight:
            manualModeButton.isSelected = false
            leftRightModeButton.isSelected = true
            pictureinPictureModeButton.isSelected = false
            break
        case .pictureAndPicture:
            manualModeButton.isSelected = false
            leftRightModeButton.isSelected = false
            pictureinPictureModeButton.isSelected = true
            break
        }
    }
    
    deinit {
       removeKeyboardObserver()
       trtcCloud.stopLocalPreview()
       trtcCloud.stopLocalAudio()
       trtcCloud.exitRoom()
       TRTCCloud.destroySharedIntance()
   }
}

//MARK: - UI Layout
extension PushCDNAnchorViewController {
    
    // 构建视图
    private func constructViewHierarchy() {
        view.addSubview(roomNumberLabel)
        view.addSubview(streamIDLabel)
        view.addSubview(roomIDTextField)
        view.addSubview(streamIDTextField)
        view.addSubview(startPushButton)
        view.addSubview(manualModeButton)
        view.addSubview(leftRightModeButton)
        view.addSubview(moreMixStreamButton)
        view.addSubview(pictureinPictureModeButton)
        view.addSubview(streamURLTextView)
        view.addSubview(audienceViewA)
        view.addSubview(audienceViewB)
        view.addSubview(audienceViewC)
    }
    
    // 视图布局
    private func activateConstraints() {
        
        audienceViewA.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(160)
            make.top.equalTo(80)
            make.trailing.equalTo(-20)
        }
        
        audienceViewB.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(160)
            make.top.equalTo(audienceViewA.snp.bottom).offset(10)
            make.trailing.equalTo(-20)
        }
        
        audienceViewB.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(160)
            make.top.equalTo(audienceViewB.snp.bottom).offset(10)
            make.trailing.equalTo(-20)
        }
        
        streamURLTextView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.height.equalTo(44)
            make.top.equalTo(550)
            make.width.equalTo(350)
        }
        
        moreMixStreamButton.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(40)
            make.top.equalTo(streamURLTextView.snp.bottom).offset(10)
            make.leading.equalTo(streamURLTextView)
        }
        
        manualModeButton.snp.makeConstraints { make in
            make.top.equalTo(moreMixStreamButton.snp.bottom).offset(5)
            make.leading.equalTo(moreMixStreamButton.snp.leading)
            make.height.equalTo(30)
            make.width.equalTo(moreMixStreamButton.snp.width).dividedBy(3).offset(-10)
        }

        leftRightModeButton.snp.makeConstraints { make in
            make.top.equalTo(manualModeButton)
            make.left.equalTo(manualModeButton.snp.right).offset(10)
            make.width.equalTo(manualModeButton)
            make.height.equalTo(manualModeButton)
        }

        pictureinPictureModeButton.snp.makeConstraints { make in
            make.top.equalTo(manualModeButton)
            make.left.equalTo(leftRightModeButton.snp.right).offset(10)
            make.width.equalTo(manualModeButton)
            make.height.equalTo(manualModeButton)
        }

        roomNumberLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(25)
            make.top.equalTo(manualModeButton.snp.bottom).offset(15)
            make.left.equalTo(20)
        }

        streamIDLabel.snp.makeConstraints { make in
            make.width.equalTo(roomNumberLabel)
            make.height.equalTo(roomNumberLabel)
            make.top.equalTo(roomNumberLabel)
            make.left.equalTo(streamIDTextField)
        }

        roomIDTextField.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(34)
            make.top.equalTo(roomNumberLabel.snp.bottom).offset(10)
            make.left.equalTo(roomNumberLabel)
        }

        streamIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDTextField)
            make.height.equalTo(roomIDTextField)
            make.top.equalTo(roomIDTextField)
            make.left.equalTo(roomIDTextField.snp.right).offset(20)
        }

        startPushButton.snp.makeConstraints { make in
            make.width.equalTo(streamIDTextField)
            make.height.equalTo(streamIDTextField)
            make.top.equalTo(streamIDTextField)
            make.left.equalTo(streamIDTextField.snp.right).offset(30)
        }
    }
    
    // 绑定事件 / 回调
    private func bindInteraction() {
        moreMixStreamButton.addTarget(self, action: #selector(onStartPublishCDNStreamClick(sender: )), for: .touchUpInside)
        startPushButton.addTarget(self, action: #selector(onStartPushTRTCClick(sender: )), for: .touchUpInside)
        manualModeButton.addTarget(self, action: #selector(onManualModeClick(sender: )), for: .touchUpInside)
        leftRightModeButton.addTarget(self, action: #selector(onLeftRightModeClick(sender: )), for: .touchUpInside)
        pictureinPictureModeButton.addTarget(self, action: #selector(onPictureInPictureModeClick(sender: )), for: .touchUpInside)
    }
}

//MARK: - Button Actions
extension PushCDNAnchorViewController {
    
    @objc func onStartPushTRTCClick(sender: UIButton) {
        if(roomIDTextField.text?.count == 0) {
            return
        }
        
        if(streamIDTextField.text?.count == 0) {
            return
        }
        
        sender.isSelected = !sender.isSelected
        resignTextFieldFirstResponder()
        if(sender.isSelected) {
            isStartPush = true
            refreshViewTitle()
            enterTRTCRoom()
        } else {
            isStartPush = false
            exitTRTCRoom()
        }
    }
    
    @objc func onStartPublishCDNStreamClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let streamId = streamIDTextField.text else {
            return
        }
        guard let roomId = roomIDTextField.text else {
            return
        }
        if(Int32(streamId) == 0 || Int32(roomId) == 0) {
            return
        }
        
        showMixConfigLink()
        transcodingConfig.streamId = streamId
        switch showMode {
        case .manual:
            setManualModeShowStatus()
            break
        case .leftAndRight:
            setLeftRightModeShowStatus()
            break
        case .pictureAndPicture:
            setLeftRightModeShowStatus()
            break
        }
        trtcCloud.setMix(transcodingConfig)
    }
    
    @objc func onManualModeClick(sender: UIButton) {
        setShowMode(showMode: .manual)
        if(isStartPush) {
            setManualModeShowStatus()
        }
    }
    
    @objc func onLeftRightModeClick(sender: UIButton) {
        setShowMode(showMode: .leftAndRight)
        if(isStartPush) {
            setLeftRightModeShowStatus()
        }
    }
    
    @objc func onPictureInPictureModeClick(sender: UIButton) {
        setShowMode(showMode: .pictureAndPicture)
        if(isStartPush) {
            setPictureinPictureModeShowStatus()
        }
    }
    
}

//MARK: - SetMixConfig
extension PushCDNAnchorViewController {
    func setManualModeShowStatus() {
        transcodingConfig.mode = TRTCTranscodingConfigMode.manual
        mixUsers.removeAll()
        
        let local: TRTCMixUser = TRTCMixUser()
        local.userId = userID
        local.zOrder = 1
        local.rect   = CGRect(x: 0, y: 0, width: Int(self.transcodingConfig.videoWidth), height: Int(self.transcodingConfig.videoHeight))
        local.roomID = nil
        local.inputType = .audioVideo
        local.streamType = .big
        mixUsers.append(local)
        
        var index: Int32 = 0
        for id in remoteUserIdSet {
            let remote = TRTCMixUser()
            guard let userId = id as? String else {
                return
            }
            remote.userId = userId
            remote.zOrder = index + 2
            remote.rect = CGRect(x: Double(transcodingConfig.videoWidth) * 0.2 * Double(index+1),
                                 y: Double(transcodingConfig.videoHeight) * 0.2 * Double(index + 1),
                                 width: 180.0, height: 180 * 1.6)
            remote.roomID = roomIDTextField.text
            remote.inputType = .audioVideo
            remote.streamType = .big
            mixUsers.append(remote)
            
            index += 1
        }
        
        transcodingConfig.mixUsers = mixUsers
        trtcCloud.setMix(transcodingConfig)
    }
    
    func setLeftRightModeShowStatus() {
        transcodingConfig.mode = TRTCTranscodingConfigMode.template_PresetLayout
        mixUsers.removeAll()
        
        let local = TRTCMixUser()
        local.userId = "$PLACE_HOLDER_LOCAL_MAIN$"
        local.zOrder = 0
        local.rect   = CGRect(x: 0.0, y: 0.0, width: Double(self.transcodingConfig.videoWidth) * 0.5,
                              height: Double(self.transcodingConfig.videoHeight))
        local.roomID = nil
        mixUsers.append(local)
        
        let remote = TRTCMixUser()
        remote.userId = "$PLACE_HOLDER_REMOTE$"
        remote.zOrder = 1
        remote.rect = CGRect(x: Double(transcodingConfig.videoWidth) * 0.5, y: 0, width: Double(transcodingConfig.videoWidth) * 0.5,
                             height: Double(transcodingConfig.videoHeight))
        remote.roomID = roomIDTextField.text
        mixUsers.append(remote)
        
        transcodingConfig.mixUsers = mixUsers
        trtcCloud.setMix(transcodingConfig)
        
    }
    
    func setPictureinPictureModeShowStatus() {
        transcodingConfig.mode = TRTCTranscodingConfigMode.template_PresetLayout
        mixUsers.removeAll()
        
        let local = TRTCMixUser()
        local.userId = "$PLACE_HOLDER_LOCAL_MAIN$"
        local.zOrder = 0
        local.rect = CGRect(x: 0, y: 0, width: Int(transcodingConfig.videoWidth), height: Int(transcodingConfig.videoHeight))
        local.roomID = nil
        mixUsers.append(local)
        
        let remote = TRTCMixUser()
        remote.userId = "$PLACE_HOLDER_REMOTE$"
        remote.zOrder = 1
        remote.rect = CGRect(x: Double(transcodingConfig.videoWidth) - 180 - 20, y: Double(transcodingConfig.videoHeight) * 0.1,
                             width: 180, height: 180 * 1.6)
        remote.roomID = roomIDTextField.text
        mixUsers.append(remote)
        
        transcodingConfig.mixUsers = mixUsers
        trtcCloud.setMix(transcodingConfig)
    }
}

//MARK: - trtc methodg
extension PushCDNAnchorViewController {
    func enterTRTCRoom() {
        trtcCloud.startLocalPreview(true, view: view)
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        guard let roomID = roomIDTextField.text else {
            return
        }
        params.roomId = UInt32((roomID as NSString).integerValue)
        params.userId = userID
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId) as String
        params.role = .anchor
        params.streamId = streamIDTextField.text
        
        trtcCloud.enterRoom(params, appScene: .LIVE)
        trtcCloud.startLocalAudio(.music)
    }
    
    func showMixConfigLink() {
        let streamURl = Localize("TRTC-API-Example.PushCDNAnchor.pushStreamAddress")
        streamURLTextView.text = streamURl
        streamURLTextView.alpha = 0.8
    }
    
    func exitTRTCRoom() {
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        
        var index: Int = 0
        for id in remoteUserIdSet {
            remoteViewArr[index].isHidden = true
            if let userId = id as? String {
                trtcCloud.stopRemoteView(userId, streamType: .small)
                index += 1
            } else {
                continue
            }
        }
        remoteUserIdSet.removeAllObjects()
    }
    
    func checkMixConfigButtonEnable() {
        let enable = remoteUserIdSet.count >= 1
        moreMixStreamButton.isUserInteractionEnabled = enable
        if enable {
            moreMixStreamButton.setTitle(Localize("TRTC-API-Example.PushCDNAnchor.mixConfig"), for: .normal)
            moreMixStreamButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        } else {
            moreMixStreamButton.setTitle(Localize("TRTC-API-Example.PushCDNAnchor.mixConfignot"), for: .normal)
            moreMixStreamButton.backgroundColor = .gray
        }
    }
    
    func showRemoteUserViewWith(userId: String) {
        if remoteUserIdSet.count < RemoteUserMaxNum {
            let count = remoteUserIdSet.count
            remoteUserIdSet.add(userId)
            trtcCloud.startRemoteView(userId, streamType: .small, view: remoteViewArr[count])
        }
        
        if isStartPush {
            switch showMode {
            case .manual:
                setManualModeShowStatus()
                break
            case .leftAndRight:
                setLeftRightModeShowStatus()
                break
            case.pictureAndPicture:
                setPictureinPictureModeShowStatus()
                break
            }
        }
    }
    
    func hiddenRemoteUserViewWith(userId: String) {

        trtcCloud.stopRemoteView(userId, streamType: .small)
        remoteUserIdSet.remove(userId)
        if isStartPush {
            switch showMode {
            case .manual:
                setManualModeShowStatus()
                break
            case .leftAndRight:
                setLeftRightModeShowStatus()
                break
            case.pictureAndPicture:
                setPictureinPictureModeShowStatus()
                break
            }
        }
    }
}

//MARK: - TRTCCloudDelegate
extension PushCDNAnchorViewController: TRTCCloudDelegate {
    
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        let index = remoteUserIdSet.index(of: userId)
        if available {
            if index == NSNotFound {
                showRemoteUserViewWith(userId: userId)
            }
        }else {
                if index != NSNotFound {
                    hiddenRemoteUserViewWith(userId: userId)
                }
            }
        checkMixConfigButtonEnable()
    }
}

//MARK: - Keyboard Observer
extension PushCDNAnchorViewController {
    
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
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        resignTextFieldFirstResponder()
    }
    
    func resignTextFieldFirstResponder() {
        if roomIDTextField.isFirstResponder {
            roomIDTextField.resignFirstResponder()
        }
        
        if streamIDTextField.isFirstResponder {
            streamIDTextField.resignFirstResponder()
        }
    }
    
    func refreshViewTitle() {
        guard let roomID = roomIDTextField.text else {
            return
        }
        title = LocalizeReplace(Localize("TRTC-API-Example.PushCDNAnchor.Title"), roomID)
    }
    
}

extension PushCDNAnchorViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomIDTextField.resignFirstResponder()
        streamIDTextField.resignFirstResponder()
        return true
    }
}
