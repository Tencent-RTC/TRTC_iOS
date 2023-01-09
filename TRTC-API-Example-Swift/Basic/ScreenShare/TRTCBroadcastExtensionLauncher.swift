//
//  TRTCBroadcastExtensionLauncher.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import ReplayKit
/*
 录屏直播功能
 TRTC APP 录屏直播功能
 本文件展示如何集成录屏直播功能
 1、RPSystemBroadcastPickerView开启app录屏功能:let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
 2、设置preferredExtension：picker.preferredExtension = bundle.bundleIdentifier
 参考文档：https://cloud.tencent.com/document/product/647/45750
 */

/*
 Screen Recording Live Streaming
 The TRTC app supports screen recording live streaming.
 This document shows how to integrate the screen recording live streaming feature.
 1. RPSystemBroadcastPickerView enable app screen recoding function : let picker =
     RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
 2. Set preferredExtension：picker：picker.preferredExtension = bundle.bundleIdentifier
 Documentation: https://cloud.tencent.com/document/product/647/45750
 */
@available(iOS 12.0, *)
class TRTCBroadcastExtensionLauncher: NSObject {
    
    var systemBroacastExtensionPicker = RPSystemBroadcastPickerView()
    var prevLaunchEventTime : CFTimeInterval = 0
    
    static let sharedInstance =  TRTCBroadcastExtensionLauncher()
    
    override init() {
        super.init()
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        picker.showsMicrophoneButton = false
        picker.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        systemBroacastExtensionPicker = picker
        
        if let pluginPath = Bundle.main.builtInPlugInsPath,
            let contents = try? FileManager.default.contentsOfDirectory(atPath: pluginPath) {
            
            for content in contents where content.hasSuffix(".appex") {
                guard let bundle = Bundle(path: URL(fileURLWithPath: pluginPath).appendingPathComponent(content).path),
                    let identifier : String = (bundle.infoDictionary?["NSExtension"] as? [String:Any])? ["NSExtensionPointIdentifier"] as? String
                    else {
                        continue
                }
                if identifier == "com.apple.broadcast-services-upload" {
                    picker.preferredExtension = bundle.bundleIdentifier
                    break
                }
            }
        }
    }
    
    static func launch() {
        TRTCBroadcastExtensionLauncher.sharedInstance.launch()
    }
    
    func launch() {
        // iOS 12 上弹出比较慢，如果快速点击会Crash
        let now = CFAbsoluteTimeGetCurrent()
        if now - prevLaunchEventTime < 1.0 {
            return
        }
        prevLaunchEventTime = now

        for view in systemBroacastExtensionPicker.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .allTouchEvents)
                break
            }
        }
    }
}
