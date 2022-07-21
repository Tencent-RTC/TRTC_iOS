//
//  SubCloudHelper.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import ObjectiveC
import TXLiteAVSDK_TRTC

protocol SubCloudHelperDelegate : NSObjectProtocol{
    func onUserVideoAvailableWithSubId(subId:UInt32,userId userId:String,available available:Bool)
}


class SubCloudHelper:NSObject,TRTCCloudDelegate{
    override init() {
        super.init()
    }
     var subId : UInt32 = 0
     var trtcCloud = TRTCCloud()
     var delegate : SubCloudHelperDelegate? = nil
    
     func initWithSubid(subid : UInt32 , cloud: TRTCCloud)->SubCloudHelper{
        subId = subid
        trtcCloud = cloud
        trtcCloud.delegate = self
        return self
    }
    
    func getCloud()->TRTCCloud{
        return trtcCloud
    }
    
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        if self.delegate != nil && (self.delegate?.responds(to: Selector.init(("onUserVideoAvailableWithSubId:userId:available:"))))! {
            delegate?.onUserVideoAvailableWithSubId(subId: subId, userId: userId, available: available)
    }
    }
}
