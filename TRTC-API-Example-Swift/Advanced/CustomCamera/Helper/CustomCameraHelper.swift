//
//  CustomCameraHelper.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum AVCamSetupResult:Int32 {
    case success
    case cameraNotAuthorized
    case sessionConfigurationFailed
}

/*
 自定义视屏采集和渲染
 TRTC APP 支持自定义视频数据采集, 本文件展示如何使用AVFoundation库自定义采集数据
 1、配置采集数据的输出设备和输入设备 API：configureSession()
 2、将音视频输入输出设备添加到会话中 API：captureSession.addInput(audioDeviceInput) captureSession.addOutput(videoOutput)
 更多细节，详见：https://cloud.tencent.com/document/product/647/34066
 */
/*
 Custom Video Capturing and Rendering
 TRTC app supports custom video data collection. This document shows how to use avfoundation library to customize data collection.
 1. Configure the output device and input device for data collection : configureSession()
 2. Add audio and video I / O devices to the session : captureSession.addInput(audioDeviceInput) captureSession.addOutput(videoOutput)
 For more information, please see https://cloud.tencent.com/document/product/647/34066
 */
@objc protocol CustomCameraHelperSampleBufferDelegate: NSObjectProtocol {
    @objc optional func onVideoSampleBuffer(videoBuffer:CMSampleBuffer)
}

class  CustomCameraHelper: NSObject {
    let sessionQueue = DispatchQueue(label: "com.txc.SessionQueue")
    let cameraDelegateQueue = DispatchQueue(label: "com.txc.CameraDelegateQueue")
    var setupResult = AVCamSetupResult(rawValue: 0)
    var captureSession = AVCaptureSession()
    var videoInput : AVCaptureDeviceInput? = nil
    var videoOutput : AVCaptureVideoDataOutput? = nil
    var audioInput : AVCaptureDeviceInput? = nil
    var videoConnection : AVCaptureConnection? = nil
    weak var delegate : CustomCameraHelperSampleBufferDelegate? = nil
    var windowOrientation:  UIInterfaceOrientation? = nil
    override init() {
        super.init()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted{
                    self.setupResult = .cameraNotAuthorized
                }
            }
            break
        default:
            setupResult = .cameraNotAuthorized
        }
    }
    
    func createSession () {
        captureSession = AVCaptureSession()
        checkPermission()
        DispatchQueue.main.async {
            self.configureSession()
        }
    }
    
    func configureSession() {
        if setupResult != .success {
            return
        }
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        var videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        if videoDevice == nil {
            videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        
        if let videoDevice = videoDevice {
            let videoDeviceInput = try?AVCaptureDeviceInput.init(device: videoDevice)
            guard let videoDeviceInput = videoDeviceInput else {
                setupResult = .sessionConfigurationFailed
                captureSession.commitConfiguration()
                return
            }
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                videoInput = videoDeviceInput
                videoOutput = AVCaptureVideoDataOutput.init()
                videoOutput?.setSampleBufferDelegate(self, queue: cameraDelegateQueue)
                let captureSettings = [String(kCVPixelBufferPixelFormatTypeKey):kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
                videoOutput?.videoSettings = captureSettings
                videoOutput?.alwaysDiscardsLateVideoFrames = true
                if let videoOutput = videoOutput {
                    if captureSession.canAddOutput(videoOutput) {
                        captureSession.addOutput(videoOutput)
                    }
                }
                
            }else{
                setupResult = .sessionConfigurationFailed
                captureSession.commitConfiguration()
                return
            }
            if let audioDevice = AVCaptureDevice.default(for: .audio) {
                let audioDeviceInput = try?AVCaptureDeviceInput.init(device: audioDevice)
                if let audioDeviceInput = audioDeviceInput {
                    if captureSession.canAddInput(audioDeviceInput) {
                        captureSession.addInput(audioDeviceInput)
                        audioInput = audioDeviceInput
                    }
                    captureSession.commitConfiguration()
                    if let videoConnection = videoOutput?.connection(with: .video) {
                        if videoConnection.isVideoOrientationSupported {
                            videoConnection.videoOrientation = .portrait
                        }
                        self.videoConnection = videoConnection
                    }
                }
            }
        }
    }
    
    func startCameraCapture() {
        sessionQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopCameraCapture() {
        sessionQueue.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
}

extension CustomCameraHelper : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)  {
        if connection == videoConnection {
            if self.delegate?.onVideoSampleBuffer?(videoBuffer: sampleBuffer) == nil {
                return
            }
        }
    }
}
