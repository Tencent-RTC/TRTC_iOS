//
//  PictureInPictureViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by adams on 2022/8/17.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_TRTC
import AVKit
 
/*
  Picture-in-picture function (supported by iOS15 and above)
  MLVB APP picture-in-picture function code example:
  This document shows how to implement the picture-in-picture function on iOS through the mobile live broadcast SDK
  1. Enable local custom rendering API: trtcCloud.setLocalVideoRenderDelegate(self, pixelFormat:._NV12, bufferType:.pixelBuffer)
  2. You need to enable the background decoding capability API of the SDK:
 ```
 let param: [String : Any] = ["api": "enableBackgroundDecoding",
                              "params": ["enable":true]]
 if let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) {
     let paramJsonString = String.init(data: jsonData, encoding: .utf8) ?? ""
     debugPrint("paramJsonString: \(paramJsonString)")
     trtcCloud.callExperimentalAPI(paramJsonString)
 }
 ```
 3. Use the system API to create a picture-in-picture content source:
     let contentSource = AVPictureInPictureController.ContentSource.init(sampleBufferDisplayLayer: sampleBufferDisplayLayer,
                                                                                 playbackDelegate: self)
  4. Use the system API to create a picture-in-picture controller:
     pipViewController = AVPictureInPictureController.init(contentSource: contentSource)
  5. Callback in SDK: onRenderVideoFrame(_ frame: TRTCVideoFrame, userId: String?, streamType: TRTCVideoStreamType)
     Convert pixelBuffer to SampleBuffer and hand it to AVSampleBufferDisplayLayer for rendering;
  6. Use the system API to turn on the picture-in-picture function: pipViewController.startPictureInPicture()
 */

class PictureInPictureViewController: UIViewController {
    
    lazy var trtcCloud: TRTCCloud = {
        let trtcCloud = TRTCCloud.sharedInstance()
        trtcCloud.delegate = self
        trtcCloud.setLocalVideoRenderDelegate(self, pixelFormat:._NV12, bufferType:.pixelBuffer)
        return trtcCloud
    }()
    
    var pipViewController: AVPictureInPictureController?
    var sampleBufferDisplayLayer: AVSampleBufferDisplayLayer?
    
    let startPushButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.CustomCamera.startPush"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.CustomCamera.stopPush"), for: .selected)
        return button
    }()
    
    let pictureInPictureButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.PictureInPicture.OpenPictureInPicture"), for: .normal)
        return button
    }()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIView()
        activateConstraints()
        bindInteraction()
        setupDefaultUIConfig()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        trtcCloud.exitRoom()
        pipViewController = nil
        sampleBufferDisplayLayer?.removeFromSuperlayer()
    }
  
    private func setupDefaultUIConfig() {
        roomIDTextField.delegate = self
        userIDTextField.delegate = self
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch let error {
                debugPrint(Localize("TRTC-API-Example.PictureInPicture.PermissionFailed"),error.localizedDescription)
                return
            }
            
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error {
                debugPrint(Localize("TRTC-API-Example.PictureInPicture.PermissionFailed"),error.localizedDescription)
                return
            }
            
            setupSampleBufferDisplayLayer()
            guard let sampleBufferDisplayLayer = sampleBufferDisplayLayer else {
                return
            }

            view.layer.insertSublayer(sampleBufferDisplayLayer, at: 0)
            if #available(iOS 15.0, *) {
                let contentSource = AVPictureInPictureController.ContentSource.init(sampleBufferDisplayLayer: sampleBufferDisplayLayer,
                                                                                    playbackDelegate: self)
                self.pipViewController = AVPictureInPictureController.init(contentSource: contentSource)
                self.pipViewController?.delegate = self
                self.pipViewController?.canStartPictureInPictureAutomaticallyFromInline = true
            } else {
                debugPrint(Localize("TRTC-API-Example.PictureInPicture.NotSupported"))
            }
            
        }
    }
    
    private func setupUIView() {
        view.addSubview(startPushButton)
        view.addSubview(roomIDLabel)
        view.addSubview(userIDLabel)
        view.addSubview(userIDTextField)
        view.addSubview(roomIDTextField)
        view.addSubview(pictureInPictureButton)
    }
    
    private func activateConstraints() {

        roomIDLabel.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-80)/3)
            make.left.equalTo(20)
            make.bottom.equalTo(roomIDTextField.snp.top).offset(-10)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.width.equalTo(roomIDLabel)
            make.left.equalTo(roomIDLabel.snp.right).offset(20)
            make.top.equalTo(roomIDLabel)
        }
        
        roomIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDLabel)
            make.height.equalTo(35)
            make.bottom.equalTo(startPushButton.snp.bottom)
            make.left.equalTo(roomIDLabel)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.width.equalTo(roomIDTextField)
            make.height.equalTo(35)
            make.top.equalTo(roomIDTextField)
            make.left.equalTo(roomIDTextField.snp.right).offset(20)
        }
        
        startPushButton.snp.makeConstraints { make in
            make.width.equalTo(userIDLabel)
            make.height.equalTo(35)
            make.top.equalTo(userIDTextField)
            make.left.equalTo(userIDTextField.snp.right).offset(20)
        }
        
        pictureInPictureButton.snp.makeConstraints { make in
            make.left.equalTo(roomIDLabel.snp.left)
            make.right.equalTo(startPushButton.snp.right)
            make.bottom.equalTo(self.view.safeAreaInsets.bottom).offset(-30)
            make.top.equalTo(startPushButton.snp.bottom).offset(15)
            make.height.equalTo(35)
        }
    }
    
    func bindInteraction() {
        self.startPushButton.addTarget(self, action: #selector(onStartPushButtonClick(sender:)),
                                       for: .touchUpInside)
        self.pictureInPictureButton.addTarget(self, action: #selector(onPictureInPictureButtonClick(sender:)),
                                              for: .touchUpInside)
    }
    
    func enterRoom() {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.roomId = UInt32(Int(roomIDTextField.text ?? "") ?? 0)
        params.userId = userIDTextField.text ?? ""
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: self.userIDTextField.text ?? "") as String
        params.role = .anchor
        
        trtcCloud.enterRoom(params, appScene: .LIVE)
        trtcCloud.startLocalAudio(.music)
        trtcCloud.startLocalPreview(true, view: nil)
        
        let param: [String : Any] = ["api": "enableBackgroundDecoding",
                                     "params": ["enable":true]]
        if let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) {
            let paramJsonString = String.init(data: jsonData, encoding: .utf8) ?? ""
            debugPrint("paramJsonString: \(paramJsonString)")
            trtcCloud.callExperimentalAPI(paramJsonString)
        }
    }
    
    func exitRoom() {
        trtcCloud.exitRoom()
        sampleBufferDisplayLayer?.flushAndRemoveImage()
    }
    
    func refreshViewTitle() {
        title = LocalizeReplace(Localize("TRTC-API-Example.CustomCamera.viewTitle"), self.roomIDTextField.text ?? "")
    }
}

extension PictureInPictureViewController {

    func dispatchPixelBuffer(pixelBuffer: CVPixelBuffer) {
        var timing = CMSampleTimingInfo.init(duration: .invalid,
                                             presentationTimeStamp: .invalid,
                                             decodeTimeStamp: .invalid)
        
        var videoInfo: CMVideoFormatDescription? = nil
        var result = CMVideoFormatDescriptionCreateForImageBuffer(allocator: nil,
                                                                  imageBuffer: pixelBuffer,
                                                                  formatDescriptionOut: &videoInfo)
        if result != 0 {
            return
        }
        guard let videoInfo = videoInfo else {
            return
        }
        
        var sampleBuffer: CMSampleBuffer? = nil
        result = CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                    imageBuffer: pixelBuffer,
                                                    dataReady: true,
                                                    makeDataReadyCallback: nil,
                                                    refcon: nil,
                                                    formatDescription: videoInfo,
                                                    sampleTiming: &timing,
                                                    sampleBufferOut: &sampleBuffer)
        if result != 0 {
            return
        }
        
        guard let sampleBuffer = sampleBuffer else {
            return
        }
        guard let attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer,
                                                                        createIfNecessary: true) else {
            return
        }
        CFDictionarySetValue(
                   unsafeBitCast(CFArrayGetValueAtIndex(attachments, 0), to: CFMutableDictionary.self),
                   Unmanaged.passUnretained(kCMSampleAttachmentKey_DisplayImmediately).toOpaque(),
                   Unmanaged.passUnretained(kCFBooleanTrue).toOpaque())
        guard let layer = sampleBufferDisplayLayer else { return }
        enqueueSampleBufferToLayer(sampleBuffer: sampleBuffer, layer: layer)
    }
    
    func enqueueSampleBufferToLayer(sampleBuffer:CMSampleBuffer, layer:AVSampleBufferDisplayLayer) {
        layer.enqueue(sampleBuffer)
        if layer.status == .failed {
            debugPrint(Localize("TRTC-API-Example.PictureInPicture.Errormessage"),layer.error)
            if let error = layer.error as? NSError {
                if error.code == -11847 {
                    rebuildSampleBufferDisplayLayer()
                }
            }
        }
    }
    
    func rebuildSampleBufferDisplayLayer() {
        objc_sync_enter(self)
        teardownSampleBufferDisplayLayer()
        setupSampleBufferDisplayLayer()
        objc_sync_exit(self)
    }
    
    func teardownSampleBufferDisplayLayer() {
        if self.sampleBufferDisplayLayer != nil {
            self.sampleBufferDisplayLayer?.stopRequestingMediaData()
            self.sampleBufferDisplayLayer?.removeFromSuperlayer()
            self.sampleBufferDisplayLayer = nil
        }
    }
    
    func setupSampleBufferDisplayLayer() {
        if self.sampleBufferDisplayLayer == nil {
            self.sampleBufferDisplayLayer = AVSampleBufferDisplayLayer.init()
            self.sampleBufferDisplayLayer?.frame = UIApplication.shared.keyWindow?.bounds ?? .zero
            self.sampleBufferDisplayLayer?.position = CGPoint(x:self.sampleBufferDisplayLayer?.bounds.midX ?? 0,
                                                              y: self.sampleBufferDisplayLayer?.bounds.midY ?? 0)
            self.sampleBufferDisplayLayer?.videoGravity = .resizeAspect
            self.sampleBufferDisplayLayer?.isOpaque = true
            guard let sampleBufferDisplayLayer = self.sampleBufferDisplayLayer else { return }
            self.view.layer.insertSublayer(sampleBufferDisplayLayer, at: 0)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.sampleBufferDisplayLayer?.frame = self.view.bounds
            self.sampleBufferDisplayLayer?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
            CATransaction.commit()
        }
    }
}

extension PictureInPictureViewController: TRTCCloudDelegate {
    func onExitRoom(_ reason: Int) {
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

extension PictureInPictureViewController: TRTCVideoRenderDelegate {
    func onRenderVideoFrame(_ frame: TRTCVideoFrame, userId: String?, streamType: TRTCVideoStreamType) {
        if frame.bufferType != .texture && frame.pixelFormat != ._Texture_2D {
            if let pixelBuffer = frame.pixelBuffer {
                dispatchPixelBuffer(pixelBuffer: pixelBuffer)
            }
        }
    }
}

extension PictureInPictureViewController: UITextFieldDelegate {
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

extension PictureInPictureViewController: AVPictureInPictureSampleBufferPlaybackDelegate {
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, setPlaying playing: Bool) {
        debugPrint("setPlaying")
    }
    
    func pictureInPictureControllerTimeRangeForPlayback(_ pictureInPictureController: AVPictureInPictureController) -> CMTimeRange {
        debugPrint("pictureInPictureControllerTimeRangeForPlayback")
        return CMTimeRange.init(start: .zero, duration: .positiveInfinity)
    }
    
    func pictureInPictureControllerIsPlaybackPaused(_ pictureInPictureController: AVPictureInPictureController) -> Bool {
        debugPrint("pictureInPictureControllerIsPlaybackPaused")
        return false
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    didTransitionToRenderSize newRenderSize: CMVideoDimensions) {
        debugPrint("didTransitionToRenderSize")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    skipByInterval skipInterval: CMTime,
                                    completion completionHandler: @escaping () -> Void) {
        debugPrint("skipInterval")
    }
}

extension PictureInPictureViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("pictureInPictureControllerWillStartPictureInPicture")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        self.pictureInPictureButton .setTitle(Localize("TRTC-API-Example.PictureInPicture.ClosePictureInPicture"), for: .normal)
        debugPrint("pictureInPictureControllerDidStartPictureInPicture")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    failedToStartPictureInPictureWithError error: Error) {
        debugPrint("failedToStartPictureInPictureWithError")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        debugPrint("restoreUserInterfaceForPictureInPictureStopWithCompletionHandler")
        // Execute callback closure
        completionHandler(true)
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("pictureInPictureControllerWillStopPictureInPicture")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        self.pictureInPictureButton .setTitle(Localize("TRTC-API-Example.PictureInPicture.OpenPictureInPicture"), for: .normal)
        debugPrint("pictureInPictureControllerDidStopPictureInPicture")
    }
}

extension PictureInPictureViewController {
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

// MARK: - Button Event
extension PictureInPictureViewController {
    @objc private func onPictureInPictureButtonClick(sender: UIButton) {
        //Enable picture-in-picture when clicking the picture-in-picture button
        guard let pipViewController = self.pipViewController else { return }
        if (pipViewController.isPictureInPictureActive) {
            pipViewController.stopPictureInPicture()
        } else {
            pipViewController.startPictureInPicture()
        }
    }
    
    @objc private func onStartPushButtonClick(sender: UIButton) {
        guard let roomId = self.roomIDTextField.text, let userId = self.userIDTextField.text else { return }
        if roomId.isEmpty || userId.isEmpty {
            return
        }
        
        sender.isSelected = !sender.isSelected
        sender.isEnabled = false
        if sender.isSelected {
            refreshViewTitle()
            enterRoom()
        } else {
            exitRoom()
        }
    }
}
