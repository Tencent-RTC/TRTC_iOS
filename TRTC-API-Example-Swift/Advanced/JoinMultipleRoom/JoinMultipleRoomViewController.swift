//
//  JoinMultipleRoomViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by janejntang on 2022/7/5.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC

/*
 Entering Multiple Rooms
 TRTC Multiple Room Entry
 
 This document shows how to integrate the multiple room entry feature.
 The SDK does not assign identifiers to TRTCCloud instances.
 You need to identify and distinguish instances by yourself. In the demo, subId is used to identify instances.
 Because a delegate callback must be set for each instance, SubCloudHelper is used to forward delegates, and subId is used for identification.
 
 1. Create an instance: self.trtcCloud.createSubCloud()
 2. Enter a room:
 if let subCloud = subCloudHelperArr[subId] as? SubCloudHelper {
 let trtc = subCloud.getCloud()
 trtc.enterRoom(params, appScene: .LIVE)
 }
 3. Exit a room:
 if let subCloud = subCloudHelperArr[subId] as? SubCloudHelper {
 let trtc = subCloud.getCloud()
 trtc.exitRoom()
 }
 
 Documentation: https://cloud.tencent.com/document/product/647/32258
 
 */
let maxRoom = 4
class JoinMultipleRoomViewController : UIViewController, TRTCCloudDelegate {
    
    let trtcCloud = TRTCCloud.sharedInstance()
    let subCloudHelperArr = NSMutableArray()
    
    var roomNumLabelArr : NSArray = []
    var remoteViewArr: [UIView] = []
    var roomIdArr : [UITextField] = []
    var startButtonArr :NSArray = []
    
    let leftRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    let leftRemoteLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.JoinMultipleRoom.roomNum")
        return lable
    }()
    
    let leftRemoteFiledA : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let leftRemoteButtonA : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.start"), for:.normal)
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.stop"), for:.selected)
        return button
    }()
    
    let leftRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    let leftRemoteLabelB:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.JoinMultipleRoom.roomNum")
        lable.backgroundColor = .gray
        return lable
    }()
    
    let leftRemoteFiledB : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let leftRemoteButtonB : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.start"), for:.normal)
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.stop"), for:.selected)
        return button
    }()
    
    let rightRemoteViewA:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    let rightRemoteLabelA:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.JoinMultipleRoom.roomNum")
        return lable
    }()
    
    let rightRemoteFiledA : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let rightRemoteButtonA : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.start"), for:.normal)
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.stop"), for:.selected)
        return button
    }()
    
    let rightRemoteViewB:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    let rightRemoteLabelB:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.JoinMultipleRoom.roomNum")
        return lable
    }()
    
    let rightRemoteFiledB : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(99999999 - 10000000 + 1)+10000000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let rightRemoteButtonB : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .green
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.start"), for:.normal)
        button.setTitle(Localize("TRTC-API-Example.JoinMultipleRoom.stop"), for:.selected)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        title = Localize("TRTC-API-Example.JoinMultipleRoom.title")
        trtcCloud.delegate = self
        leftRemoteFiledA.delegate = self
        leftRemoteFiledB.delegate = self
        rightRemoteFiledA.delegate = self
        rightRemoteFiledB.delegate = self
        
        roomNumLabelArr  = [leftRemoteLabelA,rightRemoteLabelA,leftRemoteLabelB,rightRemoteLabelB]
        remoteViewArr = [leftRemoteViewA,rightRemoteViewA,leftRemoteViewB,rightRemoteViewB]
        roomIdArr  = [leftRemoteFiledA,rightRemoteFiledA,leftRemoteFiledB,rightRemoteFiledB]
        startButtonArr  = [leftRemoteButtonA,rightRemoteButtonA,leftRemoteButtonB,rightRemoteButtonB]
        
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        setupSubCloud()
    }
    
    deinit {
        trtcCloud.stopLocalAudio()
        trtcCloud.stopLocalPreview()
        trtcCloud.exitRoom()
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(leftRemoteViewA)
        view.addSubview(leftRemoteLabelA)
        view.addSubview(leftRemoteFiledA)
        view.addSubview(leftRemoteButtonA)
        
        view.addSubview(leftRemoteViewB)
        view.addSubview(leftRemoteLabelB)
        view.addSubview(leftRemoteFiledB)
        view.addSubview(leftRemoteButtonB)
        
        view.addSubview(rightRemoteViewA)
        view.addSubview(rightRemoteLabelA)
        view.addSubview(rightRemoteFiledA)
        view.addSubview(rightRemoteButtonA)
        
        view.addSubview(rightRemoteViewB)
        view.addSubview(rightRemoteLabelB)
        view.addSubview(rightRemoteFiledB)
        view.addSubview(rightRemoteButtonB)
    }
    
    private func activateConstraints() {
        
        leftRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo((view.frame.width-60)/2)
            make.height.equalTo(250)
            make.left.equalTo(20)
            make.top.equalTo(100)
        }
        
        leftRemoteLabelA.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(18)
            make.left.equalTo(leftRemoteViewA)
            make.top.equalTo(leftRemoteViewA.snp.bottom).offset(10)
        }
        
        leftRemoteFiledA.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(34)
            make.left.equalTo(leftRemoteLabelA)
            make.top.equalTo(leftRemoteLabelA.snp.bottom).offset(5)
        }
        
        leftRemoteButtonA.snp.makeConstraints { make in
            make.height.equalTo(leftRemoteFiledA)
            make.left.equalTo(leftRemoteFiledA.snp.right).offset(5)
            make.right.equalTo(leftRemoteViewA.snp.right).offset(-5)
            make.top.equalTo(leftRemoteFiledA)
        }
        
        
        rightRemoteViewA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(leftRemoteViewA)
        }
        
        rightRemoteLabelA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteLabelA)
            make.height.equalTo(leftRemoteLabelA)
            make.left.equalTo(rightRemoteViewA)
            make.top.equalTo(rightRemoteViewA.snp.bottom).offset(10)
        }
        
        rightRemoteFiledA.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteFiledA)
            make.height.equalTo(leftRemoteFiledA)
            make.left.equalTo(rightRemoteLabelA)
            make.top.equalTo(rightRemoteLabelA.snp.bottom).offset(5)
        }
        
        rightRemoteButtonA.snp.makeConstraints { make in
            make.height.equalTo(leftRemoteButtonA)
            make.left.equalTo(rightRemoteFiledA.snp.right).offset(5)
            make.right.equalTo(rightRemoteViewA.snp.right).offset(-5)
            make.top.equalTo(rightRemoteFiledA)
        }
        
        leftRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewA)
            make.height.equalTo(leftRemoteViewA)
            make.left.equalTo(leftRemoteViewA)
            make.top.equalTo(leftRemoteFiledA.snp.bottom).offset(10)
        }
        
        leftRemoteLabelB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteLabelA)
            make.height.equalTo(leftRemoteLabelA)
            make.left.equalTo(leftRemoteViewB)
            make.top.equalTo(leftRemoteViewB.snp.bottom).offset(10)
        }
        
        leftRemoteFiledB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteFiledA)
            make.height.equalTo(leftRemoteFiledA)
            make.left.equalTo(leftRemoteLabelB)
            make.top.equalTo(leftRemoteLabelB.snp.bottom).offset(5)
        }
        
        leftRemoteButtonB.snp.makeConstraints { make in
            make.height.equalTo(leftRemoteButtonB)
            make.left.equalTo(leftRemoteFiledB.snp.right).offset(5)
            make.right.equalTo(leftRemoteViewB.snp.right).offset(-5)
            make.top.equalTo(leftRemoteFiledB)
        }
        
        rightRemoteViewB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteViewB)
            make.height.equalTo(leftRemoteViewB)
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(leftRemoteViewB)
        }
        
        rightRemoteLabelB.snp.makeConstraints { make in
            make.width.equalTo(rightRemoteLabelA)
            make.height.equalTo(rightRemoteLabelA)
            make.left.equalTo(rightRemoteViewB)
            make.top.equalTo(rightRemoteViewB.snp.bottom).offset(10)
        }
        
        rightRemoteFiledB.snp.makeConstraints { make in
            make.width.equalTo(leftRemoteFiledA)
            make.height.equalTo(leftRemoteFiledA)
            make.left.equalTo(rightRemoteLabelB)
            make.top.equalTo(rightRemoteLabelB.snp.bottom).offset(5)
        }
        
        rightRemoteButtonB.snp.makeConstraints { make in
            make.height.equalTo(leftRemoteButtonA)
            make.left.equalTo(rightRemoteFiledB.snp.right).offset(5)
            make.right.equalTo(rightRemoteViewB.snp.right).offset(-5)
            make.top.equalTo(rightRemoteFiledB)
        }
        
    }
    
    private func bindInteraction() {
        leftRemoteButtonA.addTarget(self,action: #selector(clickLeftRemoteButtonA(sender:)), for: .touchUpInside)
        rightRemoteButtonA.addTarget(self,action: #selector(clickRightRemoteButtonA(sender:)), for: .touchUpInside)
        leftRemoteButtonB.addTarget(self,action: #selector(clickLeftRemoteButtonB(sender:)), for: .touchUpInside)
        rightRemoteButtonB.addTarget(self,action: #selector(clickRightRemoteButtonB(sender:)), for: .touchUpInside)
    }
    
    @objc private func clickLeftRemoteButtonA(sender: UIButton) {
        leftRemoteButtonA.isSelected = !leftRemoteButtonA.isSelected
        if leftRemoteButtonA.isSelected {
            enterRoomWithSubId(subId: 0)
        }else{
            exitRoomWithSubId(subId: 0)
        }
        
    }
    
    @objc private func clickRightRemoteButtonA(sender: UIButton) {
        rightRemoteButtonA.isSelected = !rightRemoteButtonA.isSelected
        if rightRemoteButtonA.isSelected {
            enterRoomWithSubId(subId: 1)
        }else{
            exitRoomWithSubId(subId: 1)
        }
        
    }
    
    @objc private func clickLeftRemoteButtonB(sender: UIButton) {
        leftRemoteButtonB.isSelected = !leftRemoteButtonB.isSelected
        if leftRemoteButtonB.isSelected {
            enterRoomWithSubId(subId: 2)
        }else{
            exitRoomWithSubId(subId: 2)
        }
        
    }
    
    @objc private func clickRightRemoteButtonB(sender: UIButton) {
        rightRemoteButtonB.isSelected = !rightRemoteButtonB.isSelected
        if rightRemoteButtonB.isSelected {
            enterRoomWithSubId(subId: 3)
        }else{
            exitRoomWithSubId(subId: 3)
        }
    }
    
    func enterRoomWithSubId(subId:Int) {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        
        params.strRoomId = roomIdArr[subId].text ?? ""
        params.userId = "1345736"
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId)
        if let subCloud = subCloudHelperArr[subId] as? SubCloudHelper {
            let trtc = subCloud.getCloud()
            trtc.enterRoom(params, appScene: .LIVE)
        }
    }
    
    func exitRoomWithSubId(subId:Int) {
        if let subCloud = subCloudHelperArr[subId] as? SubCloudHelper {
            let trtc = subCloud.getCloud()
            trtc.exitRoom()
        }
    }
    
    func setupSubCloud() {
        for index in 0...maxRoom-1 {
            let subCloudHelper = SubCloudHelper()
            subCloudHelper.subId = UInt32(index)
            subCloudHelper.trtcCloud = trtcCloud.createSub()
            subCloudHelper.delegate = self
            subCloudHelperArr.add(subCloudHelper)
        }
    }
    
    func destroyTRTCCloud () {
        TRTCCloud.destroySharedIntance()
        trtcCloud.exitRoom()
    }
    
    
}

extension JoinMultipleRoomViewController:UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        leftRemoteFiledA.resignFirstResponder()
        leftRemoteFiledB.resignFirstResponder()
        rightRemoteFiledA.resignFirstResponder()
        rightRemoteFiledB.resignFirstResponder()
        return true
    }
}

extension JoinMultipleRoomViewController:SubCloudHelperDelegate {
    func onUserVideoAvailableWithSubId(subId: UInt32, userId: String, available: Bool) {
        if available {
            if let subCloud = subCloudHelperArr[Int(subId)] as? SubCloudHelper {
                let trtc = subCloud.getCloud()
                trtc.startRemoteView(userId, streamType: .small, view: remoteViewArr[Int(subId)])
            }
        } else {
            if let subCloud = subCloudHelperArr[Int(subId)] as? SubCloudHelper {
                let trtc = subCloud.getCloud()
                trtc.stopRemoteView(userId, streamType: .small)
            }
        }
    }
}




