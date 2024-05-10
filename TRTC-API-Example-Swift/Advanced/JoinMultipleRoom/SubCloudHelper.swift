//
//  SubCloudHelper.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import ObjectiveC
import TXLiteAVSDK_TRTC

@objc protocol SubCloudHelperDelegate : NSObjectProtocol {
    @objc optional func onUserVideoAvailableWithSubId(subId: UInt32, userId: String, available: Bool)
}

class SubCloudHelper:NSObject,TRTCCloudDelegate {
    
    var trtcCloud = TRTCCloud()
    var subId : UInt32 = 0
    weak var delegate : SubCloudHelperDelegate? = nil
    
    override init() {
        super.init()
        trtcCloud.delegate = self
    }
    
    func getCloud()->TRTCCloud {
        return trtcCloud
    }
    
    func onUserVideoAvailable(_ userId: String, available: Bool) {
        if self.delegate?.onUserVideoAvailableWithSubId?(subId: subId, userId: userId, available: available) == nil {
            return
        }
    }
}
