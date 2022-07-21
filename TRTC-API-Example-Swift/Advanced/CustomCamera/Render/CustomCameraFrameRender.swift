//
//  CustomCameraFrameRender.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
import TXLiteAVSDK_TRTC
import CoreFoundation

class CustomCameraFrameRender:NSObject{
    override init() {
        userVideoViews = NSMutableDictionary()
        queue = DispatchQueue(label: "")
        localVideoView = UIImageView()
    }
    
    var localVideoView: UIImageView
    var userVideoViews : NSMutableDictionary
    var queue : DispatchQueue
    
    func start(userId : String,videoView videoView: UIImageView){
        if userId == nil{
            localVideoView = videoView
        }
        else{
            userVideoViews.setObject(videoView, forKey: userId as NSCopying)
        }
    }
    
    func onRenderVideoFrame(frame: TRTCVideoFrame , userId userId: String ,streamType streamType: TRTCVideoStreamType){
        DispatchQueue.main.async {
            var videoView = UIImageView()
            if userId != nil{
                videoView = self.userVideoViews.object(forKey: userId) as! UIImageView
            }else{
                videoView = self.localVideoView
            }
            if let pixelBuffer = frame.pixelBuffer{
                videoView.image = UIImage.init(ciImage: CIImage.init(cvImageBuffer: pixelBuffer))
                videoView.contentMode = .scaleAspectFit
            }
            
        }
    }
    
    func stop(){
        UIGraphicsBeginImageContext(localVideoView.bounds.size)
        let color = UIColor()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        localVideoView.image = image
    }
}
