//
//  PushCDNAudienceViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/7/13.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_TRTC

/*
 CDN发布功能 - 观众端
 TRTC APP CDN发布功能
 本文件展示如何集成CDN发布功能
 1、设置播放器代理。 API: livePlayer.setObserver(self)
 2、设置播放容器视图。 API: livePlayer.setRenderView(playerView)
 2、开始播放。 API: livePlayer.startPlay(streamUrl)
 参考文档：https://cloud.tencent.com/document/product/647/16827
 */
/*
 CDN Publishing - Audience
 TRTC CDN Publishing
 This document shows how to integrate the CDN publishing feature.
 1. Set the player delegate: livePlayer.setObserver(self)
 2. Set the player container view: livePlayer.setRenderView(playerView)
 3. Start playback: livePlayer.startPlay(streamUrl)
 Documentation: https://cloud.tencent.com/document/product/647/16827
 */

class PushCDNAudienceViewController: UIViewController {
    let streamIDLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = Localize("TRTC-API-Example.PushCDNAudience.pushStreamAddress")
        label.font = .systemFont(ofSize: 15.0)
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let streamIDTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 14.0)
        textField.placeholder = Localize("TRTC-API-Example.PushCDNAudience.inputStreamId")
        return textField
    }()
    
    var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let startPlayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle(Localize("TRTC-API-Example.PushCDNAudience.startPlay"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.PushCDNAudience.stopPlay"), for: .selected)
        return button
    }()
    
    let livePlayer: V2TXLivePlayer = V2TXLivePlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = ""
    }
    
    deinit {
        stopPaly()
    }
}

//MARK: - UI Layout
extension PushCDNAudienceViewController {
    // 构建视图
    private func constructViewHierarchy() {
        view.addSubview(streamIDTextField)
        view.addSubview(streamIDLabel)
        view.addSubview(playerView)
        view.addSubview(startPlayButton)
    }
    
    // 视图布局
    private func activateConstraints() {
        streamIDLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(130)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        streamIDTextField.snp.makeConstraints { make in
            make.top.equalTo(streamIDLabel.snp.bottom).offset(10)
            make.left.equalTo(streamIDLabel)
            make.height.equalTo(34)
            make.width.equalTo(streamIDLabel)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(streamIDTextField.snp.bottom).offset(20)
            make.bottom.equalTo(startPlayButton.snp.top).offset(-20)
            make.left.equalTo(streamIDLabel)
            make.width.equalTo(streamIDLabel)
        }
        
        startPlayButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-25)
            make.left.equalTo(playerView)
            make.width.equalTo(streamIDLabel)
            make.height.equalTo(44)
        }
    }
    
    // 绑定事件 / 回调
    private func bindInteraction() {
        startPlayButton.addTarget(self, action: #selector(onPlayClick(sender: )), for: .touchUpInside)
    }
}

//MARK: - Button Actions
extension PushCDNAudienceViewController {
    func startPlay() {
        guard let streamId = streamIDTextField.text else {
            return
        }
        let streamUrl = kCDN_URL + "/" + streamId + ".flv"
        livePlayer.setObserver(self)
        livePlayer.setRenderView(playerView)
        let ret: V2TXLiveCode = livePlayer.startPlay(streamUrl)
        if ret.rawValue != 0 {
            print(String(format: "play error. code: %ld", ret.rawValue))
        }
    }
    
    func stopPaly() {
        livePlayer.setObserver(nil)
        livePlayer.setRenderView(nil)
        livePlayer.stopPlay()
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if streamIDTextField.isFirstResponder {
            streamIDTextField.resignFirstResponder()
        }
    }
    
    @objc func onPlayClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            startPlay()
        } else {
            stopPaly()
        }
    }
}

//MARK: - V2TXLivePlayerObserver
extension PushCDNAudienceViewController: V2TXLivePlayerObserver {
    
    func onError(_ player: V2TXLivePlayerProtocol, code: V2TXLiveCode, message msg: String, extraInfo: [AnyHashable : Any]) {
        print("onError: message: \(msg ?? "")")
    }
    
    func onVideoPlaying(_ player: V2TXLivePlayerProtocol, firstPlay: Bool, extraInfo: [AnyHashable : Any]) {
        print("onVideoPlaying")
    }
    
}
