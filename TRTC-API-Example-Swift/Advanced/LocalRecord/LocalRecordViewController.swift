//
//  LocalRecordViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/28.
//  Copyright © 2022 Tencent. All rights reserved.
//
/*
 本地媒体录制示例
 TRTC APP 支持本地媒体录制功能
 本文件展示如何集成本地媒体录制功能
 1、进入TRTC房间。 API:[self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
 2、开启本地录制。  API:[self.trtcCloud startLocalRecording];
 3、结束本地录制。  API:[self.trtcCloud stopLocalRecording];
 参考文档：https://cloud.tencent.com/document/product/647/32258
 */
/*
 Local Recording
 The TRTC app supports local recording.
 This document shows how to integrate the local recording feature.
 1. Enter a room: [self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE]
 2. Start local recording: [self.trtcCloud startLocalRecording]
 3. Stop local recording: [self.trtcCloud stopLocalRecording]
 Documentation: https://cloud.tencent.com/document/product/647/32258
 */

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
import Photos

class LocalRecordViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        trtcCloud.delegate = self
        recordAddressTextField.delegate = self
        roomIdTextField.delegate = self
        title = LocalizeReplace("TRTC-API-Example.LocalRecord.Title", roomIdTextField.text ?? "")
        isStartPushStream = false
        isRecording = false
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
    }
    
    let bottomConstraint = NSLayoutConstraint()
    var trtcCloud = TRTCCloud.sharedInstance()
    var isStartPushStream : Bool = true
    var isRecording: Bool = true
    
    let recordLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.isHidden = true
        lable.text = Localize("TRTC-API-Example.LocalRecord.recordFileAddress")
        lable.adjustsFontSizeToFitWidth = true
//        lable.backgroundColor = .gray
        return lable
    }()
    
    let recordAddressLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
//        lable.backgroundColor = .gray
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.LocalRecord.recordFileAddress")
        return lable
    }()
    
    let roomIdLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
//        lable.backgroundColor = .gray
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.LocalRecord.roomId")
        return lable
    }()
    
    let recordAddressTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
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
    
    let recordButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle(Localize("TRTC-API-Example.LocalRecord.startRecord"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.LocalRecord.stopRecord"), for: .selected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let pushStreamButton : UIButton={
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.LocalRecord.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.LocalRecord.stopPush"), for: .selected)
        return button
    }()
    
    
}

extension LocalRecordViewController{
    
    private func setupDefaultUIConfig(){
        view.addSubview(recordLabel)
        view.addSubview(recordAddressLabel)
        view.addSubview(roomIdLabel)
        view.addSubview(recordAddressTextField)
        view.addSubview(roomIdTextField)
        view.addSubview(recordButton)
        view.addSubview(pushStreamButton)
    }
    
    private func activateConstraints(){
        recordLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.left.equalTo(20)
            make.top.equalTo(view.snp.bottom).offset(-200)
        }
        
        recordAddressLabel.snp.makeConstraints { make in
            make.width.equalTo(recordLabel)
            make.height.equalTo(recordLabel)
            make.left.equalTo(recordLabel)
            make.top.equalTo(recordLabel.snp.bottom).offset(10)
        }
        
        recordAddressTextField.snp.makeConstraints { make in
            make.width.equalTo(219)
            make.height.equalTo(34)
            make.top.equalTo(recordAddressLabel.snp.bottom).offset(5)
            make.left.equalTo(recordAddressLabel)
        }
        
        recordButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(33)
            make.top.equalTo(recordAddressTextField)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        roomIdLabel.snp.makeConstraints { make in
            make.width.equalTo(recordAddressLabel)
            make.height.equalTo(recordAddressLabel)
            make.top.equalTo(recordAddressTextField.snp.bottom).offset(5)
            make.left.equalTo(recordAddressLabel)
        }
        
        roomIdTextField.snp.makeConstraints { make in
            make.width.equalTo(recordAddressTextField)
            make.height.equalTo(recordAddressTextField)
            make.top.equalTo(roomIdLabel.snp.bottom).offset(5)
            make.left.equalTo(recordAddressTextField)
        }
        
        pushStreamButton.snp.makeConstraints { make in
            make.width.equalTo(recordButton)
            make.height.equalTo(recordButton)
            make.top.equalTo(roomIdTextField)
            make.left.equalTo(recordButton)
        }
        
    }
    
    private func bindInteraction(){
        recordButton.addTarget(self, action: #selector(clickRecordButton), for: .touchUpInside)
        pushStreamButton.addTarget(self, action: #selector(clickPushStreamButton), for: .touchUpInside)
    }
    
    @objc private func clickRecordButton(){
        recordButton.isSelected = !recordButton.isSelected
        if recordButton.isSelected{
            startRecord()
            
        }else{
            stopRecord()
            
        }
    }
    
    @objc private func clickPushStreamButton(){
        pushStreamButton.isSelected = !pushStreamButton.isSelected
        if pushStreamButton.isSelected{
            startPushStream()
            isStartPushStream = true
        }else{
            stopPushStream()
            isStartPushStream = false
        }
        if recordAddressTextField.text?.count ?? 0  > 0 && isStartPushStream{
            recordButton.backgroundColor = .green
            recordButton.isUserInteractionEnabled = true
        }else{
            recordButton.backgroundColor = .gray
            recordButton.isUserInteractionEnabled = false
        }
    }
    
    
    private func startRecord(){
        var filename = recordAddressTextField.text
        if ((filename?.hasSuffix(".mp4")) != nil){
            filename = (filename ?? "") + ".mp4"
        }
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachePath = (path.last ?? "") as String
        let filePath = URL(string: cachePath)?.appendingPathComponent(filename ?? "")
        
        let recordParams = TRTCLocalRecordingParams()
        recordParams.interval = 1000
        recordParams.filePath = filePath?.absoluteString ?? ""
        recordParams.recordType = .both
        trtcCloud.startLocalRecording(recordParams)
        isRecording = true
        
    }
    
    private func stopRecord(){
        trtcCloud.stopLocalRecording()
        isRecording = false
    }
    private func startPushStream(){
        let roomId = (roomIdTextField.text! as NSString).integerValue
        title = LocalizeReplace("TRTC-API-Example.LocalRecord.Title", roomIdTextField.text ?? "")
        trtcCloud.startLocalPreview(true, view: view)
        
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.roomId = UInt32(roomId)
        params.userId = String(arc4random()%(999999 - 100000 + 1)+100000)
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId ) as String
        
        trtcCloud.enterRoom(params, appScene: .LIVE)
        trtcCloud.startLocalAudio(.default)
        
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
    }
    
    private func destroyTRTCCloud(){
        TRTCCloud.destroySharedIntance()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
    }
}

extension LocalRecordViewController{
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
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
        trtcCloud.stopLocalRecording()
        TRTCCloud.destroySharedIntance()
    }
    
    @objc func keyboardWillShow(_ noti:NSNotification){
        let animationDuration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        UIView.animate(withDuration:animationDuration as! TimeInterval) { [self] in
            self.bottomConstraint.constant = (animationDuration as! CGRect).size.height
        }
    }
    
    @objc func keyboardWillHide(_ noti:NSNotification){
        let animationDuration = ((noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey])as! NSString).floatValue
        
        UIView.animate(withDuration: TimeInterval(animationDuration)) { [self] in
            self.bottomConstraint.constant = 20
        }
    }
}

extension LocalRecordViewController:UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recordAddressTextField.resignFirstResponder()
        return roomIdTextField.resignFirstResponder()
    }
}

extension LocalRecordViewController:TRTCCloudDelegate{
    func onLocalRecordBegin(_ errCode: Int, storagePath: String) {
        
    }
    
    func onLocalRecording(_ duration: Int, storagePath: String) {
        let second = duration / 1000
        let sec = second/60
        var min = second % 60
        var hor = 0
        if min >= 60 {
            hor = second / (60 * 60)
            min %= min
        }
        recordLabel.isHidden = false
        recordLabel.text = LocalizeReplace(Localize("TRTC-API-Example.LocalRecord.recordingxx"), String.localizedStringWithFormat("%.2ld:%.2ld:%.2ld", hor,min,sec))
    }
    
    func onLocalRecordComplete(_ errCode: Int, storagePath: String) {
        isRecording = false
        recordLabel.isHidden = true
        recordLabel.text = ""
        
        requestPhotoAuthorization {
            let photoLibrary = PHPhotoLibrary.shared()
            photoLibrary.performChanges {
                if let url = URL.init(string: storagePath){
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }
                
            } completionHandler: {[weak self] success, error in
                if success{
                    DispatchQueue.main.async {
                        self?.showAlertViewController(title: Localize("TRTC-API-Example.LocalRecord.recordSuccess"), message: Localize("TRTC-API-Example.LocalRecord.recordSuccessPath"))
                    }
                    
                }
            }
        }
    }
    
    func requestPhotoAuthorization(handler: @escaping () -> Void){
        if #available(iOS 14, *){
            let level = PHAccessLevel.readWrite
            PHPhotoLibrary.requestAuthorization(for: level) { status in
                switch status {
                case .authorized:
                    handler()
                    break
                case .limited:
                    handler()
                    break
                @unknown default:
                    break
                }
            }
            
            
        }else{
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    handler()
                    break
                @unknown default:
                    break
                }
            }
            
        }
    }
    
    func showAlertViewController(title:String,message:String){
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Localize("TRTC-API-Example.AlertViewController.determine"), style: .default)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
}








