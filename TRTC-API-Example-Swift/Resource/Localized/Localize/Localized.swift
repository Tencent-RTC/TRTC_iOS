//
//  Localized.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/27.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation

func Localize(_ key:String) -> String{
    let Localize_TableName = "Localized"
    let str = Bundle.main.localizedString(forKey: key, value:"", table:Localize_TableName)
    return str
}

func LocalizeReplace(_ origin:String,_ xxx_replace:String) -> String{
    var xxxx_replace = xxx_replace
    if xxx_replace == nil{
        xxxx_replace = ""
    }
    return origin.replacingOccurrences(of: "xxx", with: xxxx_replace)
}

func LocalizeReplaceTwoCharacter(origin:String,xxx_replace:String,yyy_replace:String)->String{
    var yyyy_replace = xxx_replace
    if yyy_replace == nil{
        yyyy_replace = ""
    }
    return LocalizeReplace(Localize(origin), xxx_replace).replacingOccurrences(of: "yyy", with: yyyy_replace)
}

