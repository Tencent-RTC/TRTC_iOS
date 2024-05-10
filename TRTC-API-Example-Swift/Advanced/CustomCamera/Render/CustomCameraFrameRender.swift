//
//  CustomCameraFrameRender.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
import CoreFoundation
/*
 Custom Video Capturing and Rendering
 TRTC APP supports custom video data collection. This document shows how to customize the data collected by rendering.
 1. Customized rendering of collected data : onRenderVideoFrame()
 For more information, please see https://cloud.tencent.com/document/product/647/34066
 */
class CustomCameraFrameRender:NSObject {
    
    var localVideoView: UIImageView
    let userVideoViews : NSMutableDictionary
    let queue : DispatchQueue
    
    override init() {
        userVideoViews = NSMutableDictionary()
        queue = DispatchQueue(label: "")
        localVideoView = UIImageView()
    }
    
    func start(userId : String?, videoView: UIImageView) {
        if let userID = userId{
            userVideoViews.setObject(videoView, forKey: userID as NSCopying)
        }else{
            localVideoView = videoView
        }
    }
    
    func onRenderVideoFrame(frame: TRTCVideoFrame , userId: String? ,streamType: TRTCVideoStreamType) {
        let pixelBuffer = frame.pixelBuffer
        DispatchQueue.main.async {
            var videoView = UIImageView()
            if let userID = userId{
                guard let videoImageView = self.userVideoViews.object(forKey: userID) as? UIImageView  else { return }
                videoView = videoImageView
            }else{
                videoView = self.localVideoView
            }
            if let pixelBuffer = pixelBuffer {
                videoView.image = UIImage.init(ciImage: CIImage.init(cvImageBuffer: pixelBuffer))
                videoView.contentMode = .scaleAspectFit
            }
        }
    }
    
    func stop() {
        UIGraphicsBeginImageContext(localVideoView.bounds.size)
        let color = UIColor()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        localVideoView.image = image
    }
}
