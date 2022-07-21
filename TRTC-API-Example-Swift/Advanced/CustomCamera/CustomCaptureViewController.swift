//
//  CustomCaptureViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//
/*
 自定义视屏采集和渲染示例
 TRTC APP 支持自定义视频数据采集, 本文件展示如何发送自定义采集数据
 1、进入TRTC房间。    API:[self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
 2、打开自定义采集功能。API:[self.trtcCloud enableCustomVideoCapture:YES];
 3、发送自定义采集数据。API:[self.trtcCloud enableCustomVideoCapture:YES];
 更多细节，详见：https://cloud.tencent.com/document/product/647/34066
 */
/*
 Custom Video Capturing and Rendering
 The TRTC app supports custom video capturing and rendering. This document shows how to send custom video data.
 1. Enter a room: [self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE]
 2. Enable custom video capturing: [self.trtcCloud enableCustomVideoCapture:YES]
 3. Send custom video data: [self.trtcCloud enableCustomVideoCapture:YES]
 For more information, please see https://cloud.tencent.com/document/product/647/34066
*/

import Foundation
import UIKit
import TXLiteAVSDK_TRTC

class CustomCaptureViewController : UIViewController, TRTCVideoRenderDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        trtcCloud.delegate = self
        roomIDTextField.delegate = self
        userIDTextField.delegate = self
        title = LocalizeReplace(Localize("TRTC-API-Example.CustomCamera.viewTitle"), roomIDTextField.text ?? "")
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
    }

    var bottomBtnConstraint = NSLayoutConstraint()
    var cameraHelper = CustomCameraHelper.init()
    var customFrameRender = CustomCameraFrameRender()
    var isSpeedTesting = false
    var trtcCloud = TRTCCloud.sharedInstance()
    var bottomConstraint = NSLayoutConstraint()
    var remoteUserIDArr : NSMutableArray = []

    let roomIDLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.CustomCamera.roomId")
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        return lable
    }()

    let userIDLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
//        lable.backgroundColor = .gray
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.CustomCamera.userId")
        return lable
    }()


    let roomIDTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(999999 - 100000 + 1)+100000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()

    let userIDTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(999999 - 100000 + 1) + 100000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()

    let startPushButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.CustomCamera.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.CustomCamera.stopPush"), for: .selected)
        return button
    }()

    let previewView : UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

}

extension CustomCaptureViewController{

    private func setupDefaultUIConfig(){
        view.addSubview(startPushButton)
        view.addSubview(roomIDLabel)
        view.addSubview(userIDLabel)
        view.addSubview(userIDTextField)
        view.addSubview(roomIDTextField)
        view.addSubview(previewView)
    }

    private func activateConstraints(){
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

    private func bindInteraction(){
        startPushButton.addTarget(self, action: #selector(startPushTRTC), for: .touchUpInside)
      }

    @objc private func startPushTRTC(){
        if roomIDTextField.text?.count == 0{
            return
        }
        if userIDTextField.text?.count == 0{
            return
        }
        startPushButton.isSelected = !startPushButton.isSelected
        startPushButton.isEnabled = false

        if startPushButton.isSelected{
            enterRoom()
        }else{
            exitRoom()
        }
    }

    private func enterRoom(){

        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.roomId = UInt32((roomIDTextField.text! as NSString).integerValue)
        params.userId = userIDTextField.text ?? ""
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: self.userIDTextField.text ?? "") as String
        params.role = .anchor

        trtcCloud.delegate = self
        trtcCloud.enterRoom(params, appScene: .LIVE)
        trtcCloud.startLocalAudio(.music)
        trtcCloud.enableCustomAudioCapture(true)
        trtcCloud.setLocalVideoRenderDelegate(self, pixelFormat: ._NV12, bufferType: .pixelBuffer)

    }

    private func exitRoom(){
        trtcCloud.exitRoom()
    }

}

extension CustomCaptureViewController{
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


//extension CustomCaptureViewController:CustomCameraHelperSampleBufferDelegate{
//
////    onVideoSampleBuffer
////    refreshRemoteVideoViews
//}
extension CustomCaptureViewController:TRTCCloudDelegate{
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        if available{
            if remoteUserIDArr.count >= maxRemoteUserNum{
                return
            }
            if !remoteUserIDArr.contains(userId){
                remoteUserIDArr.add(userId)
                refreshRemoteVideoViews()
            }
        }else{
           if  remoteUserIDArr.contains(userId){
                let index = remoteUserIDArr.index(of: userId)
                let tag = 3001 + index
                let view = view.viewWithTag(tag)
                if view != nil{
                    trtcCloud.stopRemoteView(userId, streamType: .small)
                }
                remoteUserIDArr.remove(userId)
            }
        }
    }

    func refreshRemoteVideoViews(){
        remoteUserIDArr.enumerateObjects { obj, idex, stop in
            let tag = 3001 + idex
            let view = view.viewWithTag(tag)
            if view != nil,let obj = obj as? String{
                trtcCloud.startRemoteView(obj, streamType: .small, view: view)
            }
        }
    }
    
    func onExitRoom(_ reason: Int) {
        customFrameRender.stop()
        if !startPushButton.isEnabled{
            startPushButton.isEnabled = true
        }
    }
    
    func onEnterRoom(_ result: Int) {
        if !startPushButton.isEnabled{
            startPushButton.isEnabled = true
        }
    }
    
    func onRenderVideoFrame(_ frame: TRTCVideoFrame, userId: String?, streamType: TRTCVideoStreamType) {
        customFrameRender.onRenderVideoFrame(frame: frame, userId: userId ?? "", streamType: streamType)
    }
    
    

}


extension CustomCaptureViewController:UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomIDTextField.resignFirstResponder()
        return userIDTextField.resignFirstResponder()
    }
}

