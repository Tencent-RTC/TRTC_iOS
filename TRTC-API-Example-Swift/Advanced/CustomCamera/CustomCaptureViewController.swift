//
//  CustomCaptureViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC

/*
 自定义视屏采集和渲染示例
 TRTC APP 支持自定义视频数据采集, 本文件展示如何发送自定义采集数据
 1、进入TRTC房间。    API:trtcCloud.enterRoom(params, appScene: .LIVE)
 2、打开自定义采集功能。API:trtcCloud.enableCustomVideoCapture(.big, enable: true)
 3、发送自定义采集数据。API:trtcCloud.enableCustomVideoCapture(.big, enable: true)
 更多细节，详见：https://cloud.tencent.com/document/product/647/34066
 */
/*
 Custom Video Capturing and Rendering
 The TRTC app supports custom video capturing and rendering. This document shows how to send custom video data.
 1. Enter a room: trtcCloud.enterRoom(params, appScene: .LIVE)
 2. Enable custom video capturing: trtcCloud.enableCustomVideoCapture(.big, enable: true)
 3. Send custom video data: trtcCloud.enableCustomVideoCapture(.big, enable: true)
 For more information, please see https://cloud.tencent.com/document/product/647/34066
 */
class CustomCaptureViewController : UIViewController {
    
    let cameraHelper = CustomCameraHelper.init()
    let customFrameRender = CustomCameraFrameRender()
    let trtcCloud = TRTCCloud.sharedInstance()
    var remoteUserIDArr : NSMutableArray = []
    
    let roomIDLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.CustomCamera.roomId")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let userIDLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.CustomCamera.userId")
        return lable
    }()
    
    let roomIDTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(999999 - 100000 + 1)+100000)
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
    
    let startPushButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.CustomCamera.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.CustomCamera.stopPush"), for: .selected)
        return button
    }()
    
    let previewView : UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        roomIDTextField.delegate = self
        userIDTextField.delegate = self
        cameraHelper.delegate = self
        title = LocalizeReplace(Localize("TRTC-API-Example.CustomCamera.viewTitle"), roomIDTextField.text ?? "")
        setupUIView()
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        addKeyboardObserver()
        cameraHelper.createSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraHelper.startCameraCapture()
        customFrameRender.start(userId: "", videoView: previewView)
        addKeyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraHelper.stopCameraCapture()
        customFrameRender.stop()
        removeKeyboardObserver()
    }
    
    private func setupUIView() {
        view.addSubview(startPushButton)
        view.addSubview(roomIDLabel)
        view.addSubview(userIDLabel)
        view.addSubview(userIDTextField)
        view.addSubview(roomIDTextField)
        view.addSubview(previewView)
    }
    
    private func setupDefaultUIConfig() {
        if #available(iOS 13.0, *) {
            cameraHelper.windowOrientation = self.view.window?.windowScene?.interfaceOrientation
        }else{
            cameraHelper.windowOrientation = .portrait
        }
    }
    
    private func activateConstraints() {
        previewView.snp.makeConstraints { make in
            make.right.left.equalTo(view)
            make.top.equalTo(100)
            make.height.equalTo(view.frame.size.height - 230)
        }
        
        roomIDLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-80)/3)
            make.height.equalTo(40)
            make.left.equalTo(20)
            make.top.equalTo(view.snp.bottom).offset(-100)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIDLabel)
            make.height.equalTo(roomIDLabel)
            make.left.equalTo(roomIDLabel.snp.right).offset(20)
            make.top.equalTo(roomIDLabel)
        }
        
        roomIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDLabel)
            make.height.equalTo(roomIDLabel)
            make.top.equalTo(roomIDLabel.snp.bottom).offset(5)
            make.left.equalTo(roomIDLabel)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDTextField)
            make.height.equalTo(roomIDTextField)
            make.top.equalTo(roomIDTextField)
            make.left.equalTo(roomIDTextField.snp.right).offset(20)
        }
        startPushButton.snp.makeConstraints { make in
            make.width.equalTo(userIDLabel)
            make.height.equalTo(userIDLabel)
            make.top.equalTo(userIDTextField)
            make.left.equalTo(userIDTextField.snp.right).offset(20)
        }
        
    }
    
    private func bindInteraction() {
        startPushButton.addTarget(self,action: #selector(startPushTRTC(sender:)), for: .touchUpInside)
    }
    
    @objc private func startPushTRTC(sender: UIButton) {
        if roomIDTextField.text?.count == 0 {
            return
        }
        if userIDTextField.text?.count == 0 {
            return
        }
        startPushButton.isSelected = !startPushButton.isSelected
        startPushButton.isEnabled = false
        
        if startPushButton.isSelected {
            enterRoom()
        }else {
            exitRoom()
        }
    }
    
    private func enterRoom() {
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.roomId = UInt32(Int(roomIDTextField.text ?? "") ?? 0)
        params.userId = userIDTextField.text ?? ""
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: self.userIDTextField.text ?? "") as String
        params.role = .anchor
        
        trtcCloud.delegate = self
        trtcCloud.enterRoom(params, appScene: .LIVE)
        trtcCloud.startLocalAudio(.music)
        trtcCloud.enableCustomVideoCapture(.big, enable: true)
        trtcCloud.setLocalVideoRenderDelegate(self, pixelFormat: ._NV12, bufferType: .pixelBuffer)
    }
    
    private func exitRoom() {
        trtcCloud.exitRoom()
    }
    
}

extension CustomCaptureViewController {
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
}

extension CustomCaptureViewController: TRTCVideoRenderDelegate {
    func onRenderVideoFrame(_ frame: TRTCVideoFrame, userId: String?, streamType: TRTCVideoStreamType) {
        customFrameRender.onRenderVideoFrame(frame: frame, userId: userId ?? "", streamType: streamType)
    }
}


extension CustomCaptureViewController:TRTCCloudDelegate {
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        if available{
            if remoteUserIDArr.count >= maxRemoteUserNum {
                return
            }
            if !remoteUserIDArr.contains(userId) {
                remoteUserIDArr.add(userId)
                refreshRemoteVideoViews()
            }
        }else{
            if  remoteUserIDArr.contains(userId) {
                let index = remoteUserIDArr.index(of: userId)
                let tag = 3001 + index
                let view = view.viewWithTag(tag)
                if view != nil {
                    trtcCloud.stopRemoteView(userId, streamType: .small)
                }
                remoteUserIDArr.remove(userId)
            }
        }
    }
    
    func refreshRemoteVideoViews() {
        remoteUserIDArr.enumerateObjects { obj, idex, stop in
            let tag = 3001 + idex
            let view = view.viewWithTag(tag)
            if view != nil,let obj = obj as? String {
                trtcCloud.startRemoteView(obj, streamType: .small, view: view)
            }
        }
    }
    
    func onExitRoom(_ reason: Int) {
        customFrameRender.stop()
        if !startPushButton.isEnabled {
            startPushButton.isEnabled = true
        }
    }
    
    func onEnterRoom(_ result: Int) {
        if !startPushButton.isEnabled {
            startPushButton.isEnabled = true
        }
    }
}


extension CustomCaptureViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomIDTextField.resignFirstResponder()
        userIDTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}

extension CustomCaptureViewController : CustomCameraHelperSampleBufferDelegate {
    func onVideoSampleBuffer(videoBuffer: CMSampleBuffer) {
        let videoFrame = TRTCVideoFrame()
        videoFrame.bufferType = .pixelBuffer
        videoFrame.pixelFormat = ._NV12
        videoFrame.pixelBuffer = CMSampleBufferGetImageBuffer(videoBuffer)
        trtcCloud.sendCustomVideoData(.big, frame: videoFrame)
    }
    
}

