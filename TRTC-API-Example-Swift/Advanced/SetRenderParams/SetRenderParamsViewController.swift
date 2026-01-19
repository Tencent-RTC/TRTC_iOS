//
//  SetRenderParamsViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC
/*
 Rendering Control
 TRTC Rendering Control View
 This document shows how to integrate the rendering control feature.
 1. Set the mirror mode for the preview image: trtcCloud.setLocalRenderParams(renderParams)
 2. Set the rendering mode for the preview image: trtcCloud.setLocalRenderParams(renderParams)
 3. Set the rotation (clockwise) of the preview image: trtcCloud.setLocalRenderParams(renderParams)
 4. Set the rendering mode of a remote image:
     trtcCloud.setRemoteRenderParams(remoteUserIdButton.currentTitle ?? "", streamType: .small,
     params: renderParams)
 5. Set the rotation (clockwise) of a remote image: trtcCloud.setRemoteRenderParams(remoteUserIdButton.currentTitle ?? "", streamType: .small, params:
      renderParams)
 6. Set the key code of TRTC : setupTRTCCloud()
 Documentation: https://cloud.tencent.com/document/product/647/32237
 */
class SetRenderParamsViewController : UIViewController {
    
    let trtcCloud = TRTCCloud.sharedInstance()
    var localRotation = TRTCVideoRotation(rawValue: 0)
    var localFillMode = TRTCVideoFillMode(rawValue: 0)
    var localMirroType = TRTCVideoMirrorType(rawValue: 0)
    var remoteRenderParamsDic = [String:TRTCRenderParams]()
    let remoteUidSet = type(of: NSMutableOrderedSet()).init(capacity: maxRemoteUserNum)
    var remoteViewArr  = [UIView]()
    var remoteUserIdLabelArr = [UILabel]()
    
    let roomIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.roomId")
        return lable
    }()
    
    let userIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.userId")
        
        return lable
    }()
    
    let localRotateLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.localRate")
        
        return lable
    }()
    
    let localRenderModeLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.localRenderMode")
        return lable
    }()
    
    let remoteRotateLabel : UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.remoteRate")
        return lable
    }()
    
    let remoteRenderModeLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.remoteRenderMode")
        return lable
    }()
    
    let localMirrorModeLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.localMirrorMode")
        return lable
    }()
    
    let remoteUserIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.RenderParams.remoteUserId")
        return lable
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
        filed.text = String(arc4random()%(999999 - 100000 + 1)+100000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let localRotateButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RenderParams.rotate0"), for: .normal)
        return button
    }()
    
    let localMirrorModeButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RenderParams.frontSymmetric"), for: .normal)
        return button
    }()
    
    let localFillModeButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RenderParams.renderModeFill"), for: .normal)
        return button
    }()
    
    let remoteRotateButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RenderParams.rotate0"), for: .normal)
        return button
    }()
    
    let remoteFillModeButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RenderParams.renderModeFill"), for: .normal)
        return button
    }()
    
    let remoteUserIdButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle("", for: .normal)
        return button
    }()
    
    let startButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.RenderParams.start"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.RenderParams.stop"), for: .selected)
        return button
    }()
    
    let leftRemoteLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let leftRemoteLabelB:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let leftRemoteLabelC:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let rightRemoteLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let rightRemoteLabelB:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let rightRemoteLabelC:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    
    let leftRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        
        return view
    }()
    
    let leftRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        return view
    }()
    
    let leftRemoteViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        return view
    }()
    
    let rightRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        return view
    }()
    
    let rightRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        return view
    }()
    
    let rightRemoteViewC:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localize("TRTC-API-Example.RenderParams.Title").appending(roomIdTextField.text ?? "")
        view.backgroundColor = .black
        trtcCloud.delegate = self
        roomIdTextField.delegate = self
        userIdTextField.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        addKeyboardObserver()
        remoteViewArr = [leftRemoteViewA,leftRemoteViewB,leftRemoteViewC,rightRemoteViewA,rightRemoteViewB,rightRemoteViewC]
        remoteUserIdLabelArr = [leftRemoteLabelA,leftRemoteLabelB,leftRemoteLabelC,rightRemoteLabelA,rightRemoteLabelB,rightRemoteLabelC]
        setupRemoteViews()
    }
    
    deinit {
        destroyTRTCCloud()
        removeKeyboardObserver()
    }
    
    private func setupTRTCCloud() {
        trtcCloud.startLocalPreview(true, view: view)
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.strRoomId = roomIdTextField.text ?? ""
        params.userId = userIdTextField.text ?? ""
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId) as String
        params.role = .anchor
        
        trtcCloud.delegate = self
        trtcCloud.enterRoom(params, appScene: .videoCall)
        
        let encParams =  TRTCVideoEncParam()
        encParams.videoResolution = ._640_360
        encParams.videoFps = 15
        encParams.videoBitrate = 550
        
        trtcCloud.setGSensorMode(.disable)
        trtcCloud.setVideoEncoderParam(encParams)
        trtcCloud.startLocalAudio(.music)
        
    }
    
    
    
    private func setupDefaultUIConfig() {
        view.addSubview(roomIdLabel)
        view.addSubview(userIdLabel)
        view.addSubview(localRotateLabel)
        view.addSubview(localRenderModeLabel)
        view.addSubview(roomIdLabel)
        view.addSubview(remoteRotateLabel)
        view.addSubview(remoteUserIdLabel)
        
        view.addSubview(remoteRenderModeLabel)
        view.addSubview(localMirrorModeLabel)
        view.addSubview(roomIdTextField)
        view.addSubview(userIdTextField)
        
        view.addSubview(localRotateButton)
        view.addSubview(localMirrorModeButton)
        view.addSubview(localFillModeButton)
        view.addSubview(remoteRotateButton)
        view .addSubview(remoteFillModeButton)
        view .addSubview(remoteUserIdButton)
        view .addSubview(startButton)
        
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
        
        localRenderModeLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-70)/2)
            make.height.equalTo(20)
            make.left.equalTo(20)
            make.top.equalTo(view.snp.bottom).offset(-280)
        }
        
        remoteUserIdLabel.snp.makeConstraints { make in
            make.width.equalTo(localRenderModeLabel)
            make.height.equalTo(localRenderModeLabel)
            make.left.equalTo(localRenderModeLabel.snp.right).offset(30)
            make.top.equalTo(localRenderModeLabel)
        }
        
        localFillModeButton.snp.makeConstraints { make in
            make.width.equalTo(localRenderModeLabel)
            make.height.equalTo(30)
            make.left.equalTo(localRenderModeLabel)
            make.top.equalTo(localRenderModeLabel.snp.bottom).offset(5)
        }
        
        remoteUserIdButton.snp.makeConstraints { make in
            make.width.equalTo(localFillModeButton)
            make.height.equalTo(localFillModeButton)
            make.left.equalTo(localFillModeButton.snp.right).offset(30)
            make.top.equalTo(localFillModeButton)
        }
        
        localMirrorModeLabel.snp.makeConstraints { make in
            make.width.equalTo(localRenderModeLabel)
            make.height.equalTo(localRenderModeLabel)
            make.top.equalTo(localFillModeButton.snp.bottom).offset(5)
            make.left.equalTo(localRenderModeLabel)
        }
        
        
        remoteRenderModeLabel.snp.makeConstraints { make in
            make.width.equalTo(localMirrorModeLabel)
            make.height.equalTo(localMirrorModeLabel)
            make.top.equalTo(localMirrorModeLabel)
            make.left.equalTo(localMirrorModeLabel.snp.right).offset(30)
        }
        
        localMirrorModeButton.snp.makeConstraints { make in
            make.width.equalTo(localFillModeButton)
            make.height.equalTo(localFillModeButton)
            make.top.equalTo(localMirrorModeLabel.snp.bottom).offset(5)
            make.left.equalTo(localMirrorModeLabel)
        }
        
        remoteFillModeButton.snp.makeConstraints { make in
            make.width.equalTo(localMirrorModeButton)
            make.height.equalTo(localMirrorModeButton)
            make.top.equalTo(localMirrorModeButton)
            make.left.equalTo(localMirrorModeButton.snp.right).offset(30)
        }
        
        localRotateLabel.snp.makeConstraints { make in
            make.width.equalTo(localMirrorModeLabel)
            make.height.equalTo(localMirrorModeLabel)
            make.top.equalTo(localMirrorModeButton.snp.bottom).offset(5)
            make.left.equalTo(localMirrorModeButton)
        }
        remoteRotateLabel.snp.makeConstraints { make in
            make.width.equalTo(localRotateLabel)
            make.height.equalTo(localRotateLabel)
            make.top.equalTo(localRotateLabel)
            make.left.equalTo(localRotateLabel.snp.right).offset(30)
        }
        
        localRotateButton.snp.makeConstraints { make in
            make.width.equalTo(localMirrorModeButton)
            make.height.equalTo(localMirrorModeButton)
            make.top.equalTo(localRotateLabel.snp.bottom).offset(5)
            make.left.equalTo(localRotateLabel)
        }
        
        remoteRotateButton.snp.makeConstraints { make in
            make.width.equalTo(localRotateButton)
            make.height.equalTo(localRotateButton)
            make.top.equalTo(localRotateButton)
            make.left.equalTo(localRotateButton.snp.right).offset(30)
        }
        
        
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width - 80)/3)
            make.height.equalTo(localRotateLabel)
            make.top.equalTo(localRotateButton.snp.bottom).offset(5)
            make.left.equalTo(localRotateButton)
        }
        
        userIdLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(roomIdLabel)
            make.top.equalTo(roomIdLabel)
            make.left.equalTo(roomIdLabel.snp.right).offset(20)
        }
        
        roomIdTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIdLabel)
            make.height.equalTo(localFillModeButton)
            make.top.equalTo(roomIdLabel.snp.bottom).offset(5)
            make.left.equalTo(roomIdLabel)
        }
        
        userIdTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIdTextField)
            make.height.equalTo(roomIdTextField)
            make.top.equalTo(roomIdTextField)
            make.left.equalTo(roomIdTextField.snp.right).offset(20)
        }
        
        startButton.snp.makeConstraints { make in
            make.width.equalTo(userIdTextField)
            make.height.equalTo(userIdTextField)
            make.top.equalTo(userIdTextField)
            make.left.equalTo(userIdTextField.snp.right).offset(20)
        }
    }
    
    private func bindInteraction() {
        localRotateButton.addTarget(self,action: #selector(onLocalRateButtonClick(sender:)), for: .touchUpInside)
        localMirrorModeButton.addTarget(self,action: #selector(onLocalMirrorModeClick(sender:)), for: .touchUpInside)
        localFillModeButton.addTarget(self,action: #selector(onLocalFillModeClick(sender:)), for: .touchUpInside)
        remoteRotateButton.addTarget(self,action: #selector(onRemoteRotationClick(sender:)), for: .touchUpInside)
        remoteFillModeButton.addTarget(self,action: #selector(onRemoteFillModeClick(sender:)), for: .touchUpInside)
        remoteUserIdButton.addTarget(self,action: #selector(onRemoteUserIdClick(sender:)), for: .touchUpInside)
        startButton.addTarget(self,action: #selector(onStartButton(sender:)), for: .touchUpInside)
    }
    
    private func setupRemoteViews() {
        for i in 0...remoteViewArr.count-1 {
            remoteViewArr[i].isHidden = true
            remoteUserIdLabelArr[i].isHidden = true
        }
        
    }
    
    @objc private func onLocalRateButtonClick(sender: UIButton) {
        showRateMenuListWithIsLocal(isLocal: true) { [self] rotate in
            self.localRotation = rotate
            self.reloadRenderParamsWithIsLocal(isLocal: true)
        }
    }
    
    @objc private func onLocalFillModeClick(sender: UIButton) {
        showFillModeListWithIsLocal(isLocal: true) { fillMode in
            self.localFillMode = fillMode
            self.reloadRenderParamsWithIsLocal(isLocal: true)
        }
    }
    
    @objc private func onLocalMirrorModeClick(sender: UIButton) {
        showMirrorTypeListWithHandler(isLocal: true) { mirrorType in
            self.localMirroType = mirrorType
            self.reloadRenderParamsWithIsLocal(isLocal: true)
        }
    }
    
    @objc private func onRemoteRotationClick(sender: UIButton) {
        if remoteUserIdButton.currentTitle == ""{
            showAlertViewController(title: "", message: Localize("TRTC-API-Example.RenderParams.waitOtherUser"))
            return
        }
        showRateMenuListWithIsLocal(isLocal: false) { rotate in
            self.remoteRenderParamsDic[self.remoteUserIdButton.titleLabel?.text ?? ""]?.rotation = rotate
            self.reloadRenderParamsWithIsLocal(isLocal: false)
        }
    }
    
    @objc private func onRemoteFillModeClick(sender: UIButton) {
        if  remoteUserIdButton.currentTitle == "" {
            self.showAlertViewController(title: "", message: Localize("TRTC-API-Example.RenderParams.waitOtherUser"))
            return
        }
        showFillModeListWithIsLocal(isLocal: false) { fillMode in
            self.remoteRenderParamsDic[self.remoteUserIdButton.titleLabel?.text ?? ""]?.fillMode = fillMode
            self.reloadRenderParamsWithIsLocal(isLocal: false)
        }
    }
    
    @objc private func onRemoteUserIdClick(sender: UIButton) {
        if  remoteUidSet.count == 0 {
            self.showAlertViewController(title: "", message: Localize("TRTC-API-Example.RenderParams.waitOtherUser"))
            return
        }
        showRemoteUsersListWithHandle { userId in
            self.remoteUserIdButton.setTitle(userId, for: .normal)
            self.reloadRenderParamsWithIsLocal(isLocal: false)
        }
    }
    
    func showAlertViewController(title:String,message:String) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Localize("TRTC-API-Example.AlertViewController.determine"), style: .default)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func onStartButton(sender: UIButton) {
        if startButton.isSelected {
            remoteUserIdButton.setTitle("", for: .normal)
            remoteUidSet.removeAllObjects()
            hidenRemoteViewAndLabels()
            trtcCloud.exitRoom()
            destroyTRTCCloud()
        }else {
            title = Localize("TRTC-API-Example.RenderParams.Title").appending(roomIdTextField.text ?? "")
            setupTRTCCloud()
        }
        startButton.isSelected = !startButton.isSelected
    }
    
    func destroyTRTCCloud() {
        TRTCCloud.destroySharedIntance()
        trtcCloud.exitRoom()
    }
    
    func hidenRemoteViewAndLabels() {
        if remoteViewArr.count == 0 {
            return
        }
        for i in 0...remoteViewArr.count-1 {
            remoteViewArr[i].isHidden = true
            remoteUserIdLabelArr[i].isHidden = true
        }
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
    
    func showRateMenuListWithIsLocal(isLocal:Bool,handler: @escaping (TRTCVideoRotation)->Void) {
        
        let alertTitle = isLocal ? Localize("TRTC-API-Example.RenderParams.localRate") : Localize("TRTC-API-Example.RenderParams.remoteRate")
        let alertVC = UIAlertController.init(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        let  alertAction = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.rotate0"), style: .default) { acction in
            handler(._0)
        }
        let  alertAction1 = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.rotate90"), style: .default) { acction in
            handler(._90)
        }
        let  alertAction2 = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.rotate180"), style: .default) { acction in
            handler(._180)
        }
        let  alertAction3 = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.rotate270"), style: .default) { acction in
            handler(._270)
        }
        alertVC.addAction(alertAction)
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        self.present(alertVC, animated: true,completion: nil)
    }
    
    func showMirrorTypeListWithHandler(isLocal:Bool,handler: @escaping (TRTCVideoMirrorType)->Void) {
        
        let alertTitle = Localize("TRTC-API-Example.RenderParams.localMirrorMode")
        
        let alertVC = UIAlertController.init(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        let  alertAction = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.frontSymmetric"), style: .default) { acction in
            handler(.auto)
        }
        let  alertAction1 = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.allSymmetric"), style: .default) { acction in
            handler(.enable)
        }
        let  alertAction2 = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.allKeep"), style: .default) { acction in
            handler(.disable)
        }
        
        alertVC.addAction(alertAction)
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        self.present(alertVC, animated: true,completion: nil)
    }
    
    func showFillModeListWithIsLocal(isLocal:Bool,handler: @escaping (TRTCVideoFillMode)->Void) {
        
        let alertTitle = isLocal ? Localize("TRTC-API-Example.RenderParams.localRenderMode") :
         Localize("TRTC-API-Example.RenderParams.remoteRenderMode")
        let alertVC = UIAlertController.init(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        let  alertAction = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.renderModeFill"), style: .default) { acction in
            handler(.fill)
        }
        let  alertAction1 = UIAlertAction.init(title: Localize("TRTC-API-Example.RenderParams.renderModeAdaptor"), style: .default) { acction in
            handler(.fit)
        }
        
        alertVC.addAction(alertAction)
        alertVC.addAction(alertAction1)
        self.present(alertVC, animated: true,completion: nil)
    }
    
    func showRemoteUsersListWithHandle(handler: @escaping (String)->Void) {
        
        let alertTitle = Localize("TRTC-API-Example.RenderParams.chooseUserId")
        
        let alertVC = UIAlertController.init(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        
        for userId in remoteUidSet {
            guard let userID = userId as? String else{
                continue
            }
            let alertAction = UIAlertAction.init(title: userID, style: .default) { acction in
                if let userid = userID as? String {
                    handler(userid)
                }else{
                    handler("")
                }
            }
            alertVC.addAction(alertAction)
        }
        self.present(alertVC, animated: true,completion: nil)
    }
    
    func reloadRenderParamsWithIsLocal(isLocal:Bool) {
        let rotateButton = isLocal ? localRotateButton : remoteRotateButton
        let fillModeButton = isLocal ? localFillModeButton : remoteFillModeButton
        let rotate = isLocal ? localRotation :  remoteRenderParamsDic[remoteUserIdButton.currentTitle ?? ""]?.rotation
        let fillMode = isLocal ? localFillMode :  remoteRenderParamsDic[remoteUserIdButton.currentTitle ?? ""]?.fillMode
        
        if let rotate = rotate {
            refreshRotationButton(button: rotateButton, withRotation: rotate)
        }
        if let fillMode = fillMode {
            refreshFillModeButton(button: fillModeButton, withFillMode: fillMode)
        }
        if isLocal {
            refreshLocalMirrorModeButton()
        }
        
        let renderParams = TRTCRenderParams()
        if let fillMode = fillMode {
            renderParams.fillMode = fillMode
        }
        if let rotate = rotate {
            renderParams.rotation = rotate
        }
        if isLocal {
            guard let localMirroType = localMirroType else {return}
            renderParams.mirrorType = localMirroType
            trtcCloud.setLocalRenderParams(renderParams)
        }else {
            guard let localMirroType = localMirroType else {return}
            renderParams.mirrorType = localMirroType
            trtcCloud.setRemoteRenderParams(remoteUserIdButton.currentTitle ?? "", streamType: .small, params: renderParams)
        }
        
    }
    
    func refreshRotationButton(button:UIButton, withRotation rotate:TRTCVideoRotation) {
        switch rotate {
        case ._0:
            button.setTitle(Localize("TRTC-API-Example.RenderParams.rotate0"), for: .normal)
            break
        case ._90:
            button.setTitle(Localize("TRTC-API-Example.RenderParams.rotate90"), for: .normal)
            break
        case ._180:
            button.setTitle(Localize("TRTC-API-Example.RenderParams.rotate180"), for: .normal)
            break
        case ._270:
            button.setTitle(Localize("TRTC-API-Example.RenderParams.rotate270"), for: .normal)
            break
            
        @unknown default:
            break
        }
    }
    
    func refreshFillModeButton(button:UIButton, withFillMode fillMode:TRTCVideoFillMode) {
        switch fillMode {
        case .fill:
            button.setTitle(Localize("TRTC-API-Example.RenderParams.renderModeFill"), for: .normal)
            break
        case .fit:
            button.setTitle(Localize("TRTC-API-Example.RenderParams.renderModeAdaptor"), for: .normal)
            break
        @unknown default:
            break
        }
    }
    
    func refreshLocalMirrorModeButton() {
        switch localMirroType {
        case .auto:
            localMirrorModeButton.setTitle(Localize("TRTC-API-Example.RenderParams.frontSymmetric"), for: .normal)
            break
        case .enable:
            localMirrorModeButton.setTitle(Localize("TRTC-API-Example.RenderParams.allSymmetric"), for: .normal)
            break
        case .disable:
            localMirrorModeButton.setTitle(Localize("TRTC-API-Example.RenderParams.allKeep"), for: .normal)
            break
        default:
            break
        }
    }
}

extension SetRenderParamsViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        userIdTextField.resignFirstResponder()
        roomIdTextField.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userIdTextField.resignFirstResponder()
        roomIdTextField.resignFirstResponder()
        return true
    }
}

extension SetRenderParamsViewController:TRTCCloudDelegate {
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        let index = remoteUidSet.index(of: userId)
        if available {
            if index != NSNotFound {
                return
            }
            remoteUidSet.add(userId)
            remoteRenderParamsDic.updateValue(TRTCRenderParams(), forKey: userId)
            if remoteUserIdButton.currentTitle == "" {
                remoteUserIdButton.setTitle(userId, for: .normal)
            }
        }else {
            trtcCloud.stopRemoteView(userId, streamType: .small)
            remoteUidSet.remove(userId)
            remoteRenderParamsDic.removeValue(forKey: userId)
            if remoteUidSet.count == 0 {
                remoteUserIdButton.setTitle("", for: .normal)
            }
        }
        DispatchQueue.main.async {
            self.refreshRemoteVideoViews()
        }
    }
    func refreshRemoteVideoViews(){
        var index = 0
        for userId in remoteUidSet {
            if index >= maxRemoteUserNum {
                return
            }
            remoteViewArr[index].isHidden = false
            remoteUserIdLabelArr[index].isHidden = false
            remoteUserIdLabelArr[index].text = userId as? String
            guard let userid = userId as? String else { continue }
            trtcCloud.startRemoteView(userid, streamType: .small, view: remoteViewArr[index])
            index = index + 1
        }
        for i in index...remoteViewArr.count-1 {
            remoteViewArr[i].isHidden = true
            remoteUserIdLabelArr[i].isHidden = true
        }
    }
}




