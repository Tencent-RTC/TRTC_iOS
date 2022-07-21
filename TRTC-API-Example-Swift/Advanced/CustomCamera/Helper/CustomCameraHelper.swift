//
//  CustomCameraHelper.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import AVFoundation

enum AVCamSetupResult:Int32{
    case AVCamSetupResultSuccess
    case AVCamSetupResultCameraNotAuthorized
    case AVCamSetupResultSessionConfigurationFailed
}

protocol CustomCameraHelperSampleBufferDelegate : NSObjectProtocol{
    func onVideoSampleBuffer(videoBuffer:CMSampleBuffer)
}

class  CustomCameraHelper: NSObject{
    var sessionQueue = DispatchQueue(label: "com.txc.SessionQueue")
    var cameraDelegateQueue = DispatchQueue(label: "com.txc.CameraDelegateQueue")
    var setupResult = AVCamSetupResult(rawValue: 0)
    var captureSession = AVCaptureSession()
    var videoInput : AVCaptureDeviceInput? = nil
    var videoOutput : AVCaptureVideoDataOutput? = nil
    var audioInput : AVCaptureDeviceInput? = nil
    var videoConnection : AVCaptureConnection? = nil
    let delegate : CustomCameraHelperSampleBufferDelegate? = nil
    
    override init(){
        super.init()
       
    }

    func checkPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            break
        case .notDetermined:
//            dispatch_suspend(dispatch_suspend)
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted{
                    self.setupResult = .AVCamSetupResultCameraNotAuthorized
                }
//                dispatch_resume(sessionQueue)
            }
            break
        default:
            setupResult = .AVCamSetupResultCameraNotAuthorized
        }
    }
    
    func createSession (){
        captureSession = AVCaptureSession()
        checkPermission()
        DispatchQueue.main.async {
            self.configureSession()
        }
        
    }
    func configureSession(){
        if setupResult != .AVCamSetupResultSuccess{
            return
        }
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        var videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        if videoDevice == nil{
            videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        
        if let videoDevice = videoDevice{
            let videoDeviceInput = try?AVCaptureDeviceInput.init(device: videoDevice)
            guard let videoDeviceInput = videoDeviceInput else{
                setupResult = .AVCamSetupResultSessionConfigurationFailed
                captureSession.commitConfiguration()
                return
            }
            if captureSession.canAddInput(videoDeviceInput){
                captureSession.addInput(videoDeviceInput)
                videoInput = videoDeviceInput
                videoOutput = AVCaptureVideoDataOutput.init()
                videoOutput?.setSampleBufferDelegate(self, queue: cameraDelegateQueue)
                let captureSettings = [String(kCVPixelBufferPixelFormatTypeKey):kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
                videoOutput?.videoSettings = captureSettings
                videoOutput?.alwaysDiscardsLateVideoFrames = true
                if let videoOutput = videoOutput{
                    if captureSession.canAddOutput(videoOutput){
                        captureSession.addOutput(videoOutput)
                    }
                }
                
            }else{
                setupResult = .AVCamSetupResultSessionConfigurationFailed
                captureSession.commitConfiguration()
                return
            }
            if let audioDevice = AVCaptureDevice.default(for: .audio){
                var audioDeviceInput = try?AVCaptureDeviceInput.init(device: audioDevice)
                if let audioDeviceInput = audioDeviceInput{
                    if captureSession.canAddInput(audioDeviceInput){
                        captureSession.addInput(audioDeviceInput)
                        audioInput = audioDeviceInput
                    }
                    captureSession.commitConfiguration()
                    if let videoConnection = videoOutput?.connection(with: .video){
                        if videoConnection.isVideoOrientationSupported{
                            videoConnection.videoOrientation = .portrait
                        }
                        self.videoConnection = videoConnection
                    }
                }
               
            }
        }
        
        
    }
    
    func startCameraCapture(){
        if captureSession == nil{
            return
        }
        sessionQueue.async {
            if self.captureSession.isRunning{
                self.captureSession.startRunning()
            }
        }
        
    }
    func stopCameraCapture(){
        if captureSession == nil{
            return
        }
        sessionQueue.async {
             if self.captureSession.isRunning{
                self.captureSession.stopRunning()
            }
        }
    }

}

extension CustomCameraHelper : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection == videoConnection{
            if self.delegate != nil && (self.delegate?.responds(to: Selector.init(("onVideoSampleBuffer:"))))! {
                delegate?.onVideoSampleBuffer(videoBuffer: sampleBuffer)
        }
    }
    }
}
