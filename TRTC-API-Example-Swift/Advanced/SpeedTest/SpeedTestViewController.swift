//
//  SpeedTestViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/7/4.
//  Copyright © 2022 Tencent. All rights reserved.
//
import Foundation
import UIKit
import TXLiteAVSDK_TRTC
/*
 网络测速功能
 TRTC 网络测速
 本文件展示如何集成网络测速
 1、网络测试 API: trtcCloud.startSpeedTest(UInt32(SDKAPPID), userId: userIdTextField.text ?? "", userSig: userSig) { [weak self] resul, completedCount, totalCount in  }
 参考文档：https://cloud.tencent.com/document/product/647/32239
 */
/*
 Network Speed Testing
 TRTC Network Speed Testing
 This document shows how to integrate the network speed testing capability.
 1. Test the network: trtcCloud.startSpeedTest(UInt32(SDKAPPID), userId: userIdTextField.text ?? "", userSig: userSig) { [weak self] resul, completedCount, totalCount in  }
 Documentation: https://cloud.tencent.com/document/product/647/32239
 */
class SpeedTestViewController : UIViewController, TRTCCloudDelegate {
    
    var isSpeedTesting = false
    let trtcCloud = TRTCCloud.sharedInstance()
    
    let userIdLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.SpeedTest.userId")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let speedTestLabel:UILabel = {
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.adjustsFontSizeToFitWidth = true
        lable.text = Localize("TRTC-API-Example.SpeedTest.speedTestResult")
        return lable
    }()
    
    
    let userIdTextField : UITextField = {
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = String(arc4random()%(999999 - 100000 + 1)+100000)
        filed.textColor = .black
        filed.backgroundColor = .white
        filed.returnKeyType = .done
        return filed
    }()
    
    let speedResultTextView : UITextView = {
        let filed = UITextView(frame: .zero)
        filed.keyboardAppearance = .default
        filed.returnKeyType = .done
        return filed
    }()
    
    let startButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textColor = .white
        button.backgroundColor = .gray
        button.setTitle(Localize("TRTC-API-Example.SpeedTest.beginTest"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        trtcCloud.delegate = self
        userIdTextField.delegate = self
        speedResultTextView.delegate = self
        title = Localize("TRTC-API-Example.SpeedTest.title")
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
    }
    
    private func setupDefaultUIConfig() {
        view.addSubview(userIdLabel)
        view.addSubview(speedTestLabel)
        view.addSubview(userIdTextField)
        view.addSubview(speedResultTextView)
        view.addSubview(startButton)
    }
    
    private func activateConstraints() {
        userIdLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(30)
            make.left.equalTo(20)
            make.top.equalTo(view).offset(100)
        }
        
        userIdTextField.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width-40)
            make.height.equalTo(35)
            make.left.equalTo(userIdLabel)
            make.top.equalTo(userIdLabel.snp.bottom).offset(5)
        }
        
        speedTestLabel.snp.makeConstraints { make in
            make.width.equalTo(userIdLabel)
            make.height.equalTo(userIdLabel)
            make.top.equalTo(userIdTextField.snp.bottom).offset(5)
            make.left.equalTo(userIdTextField)
        }
        
        speedResultTextView.snp.makeConstraints { make in
            make.width.equalTo(userIdTextField)
            make.top.equalTo(speedTestLabel.snp.bottom).offset(5)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
            make.left.equalTo(speedTestLabel)
        }
        startButton.snp.makeConstraints { make in
            make.width.equalTo(speedResultTextView)
            make.height.equalTo(39)
            make.top.equalTo(speedResultTextView.snp.bottom).offset(20)
            make.left.equalTo(speedResultTextView)
        }
        
    }
    
    private func bindInteraction() {
        startButton.addTarget(self, action: #selector(onStartButtonClick), for: .touchUpInside)
      }
    
    @objc private func onStartButtonClick() {
        if isSpeedTesting {
            return
        }
        if startButton.isSelected {
            startButton.setTitle(Localize("TRTC-API-Example.SpeedTest.beginTest"), for: .normal)
            speedResultTextView.text = ""
        }else {
            beginSpeedTest()
            startButton.isHighlighted = true
            startButton.setTitle("0", for: .normal)
        }
        startButton.isSelected = !startButton.isSelected
    }
    
    private func beginSpeedTest() {
        isSpeedTesting = true
        let userSig = GenerateTestUserSig.genTestUserSig(identifier: userIdTextField.text ?? "")
        trtcCloud.startSpeedTest(UInt32(SDKAPPID), userId: userIdTextField.text ?? "", userSig: userSig) { [weak self] resul, completedCount, totalCount in
            guard let strongSelf = self else { return }
            let printResult = "current server:\(completedCount), total server: \(totalCount)\n current ip: \(resul.ip), quality: \(resul.quality), upLostRate: \(resul.upLostRate * 100)\n downLostRate: \(resul.downLostRate * 100), rtt: \(resul.rtt)\n\n"
            strongSelf.speedResultTextView.text = self?.speedResultTextView.text.appending(printResult)
            if completedCount == totalCount{
                strongSelf.isSpeedTesting = false
                strongSelf.startButton.setTitle(Localize("TRTC-API-Example.SpeedTest.completedTest"), for: .normal)
                return
            }
            let complete = Float(completedCount)
            let total = Float(totalCount)
            let percent = Float(complete / total )
            let strPercent = String(format: "%.2f %%", percent * 100)
            strongSelf.startButton.setTitle(strPercent, for: .normal)
        };
    }
    private func stopPushStream() {
        trtcCloud.stopLocalPreview()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
    }
    
    private func destroyTRTCCloud() {
        TRTCCloud.destroySharedIntance()
        trtcCloud.stopLocalAudio()
        trtcCloud.exitRoom()
    }
}


extension SpeedTestViewController:UITextFieldDelegate,UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return userIdTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            speedResultTextView.resignFirstResponder()
            return false
        }
        return true
    }
}

