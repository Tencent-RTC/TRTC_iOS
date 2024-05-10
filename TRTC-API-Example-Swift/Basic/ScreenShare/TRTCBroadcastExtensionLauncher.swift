//
//  TRTCBroadcastExtensionLauncher.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import ReplayKit
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
        // The pop-up on iOS 12 is slow and will crash if you click quickly.
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
