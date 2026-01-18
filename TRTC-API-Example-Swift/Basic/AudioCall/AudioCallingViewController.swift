//
//  AudioCallingViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_TRTC

/*
Real-Time Audio Call
 TRTC Audio Call
 This document shows how to integrate the real-time audio call feature.
 1. Switch between the speaker and receiver: trtcCloud.getDeviceManager().setAudioRoute(.speakerphone)
 2. Mute the device so that others won’t hear the audio of the device: trtcCloud.muteLocalAudio(true)
 3. Display other network and volume information: delegate -> onNetworkQuality, onUserVoiceVolume
 Documentation: https://cloud.tencent.com/document/product/647/42046
*/

class UserBox: UIView {
    let userPortrait: UIImageView = {
        var imageV = UIImageView(image: UIImage(named: "audiocall_user_portrait"))
        imageV.backgroundColor = .white
        return imageV
    }()
    
    let label: UILabel = {
        var label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 90))
        contentMode = .scaleToFill
        semanticContentAttribute = .unspecified
        isUserInteractionEnabled = true
        backgroundColor = .clear
        alpha = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isViewReady = false
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard !isViewReady else {
            return
        }
        isViewReady = true
        constructViewHierarchy()
        activateConstraints()
    }
    
    private func constructViewHierarchy() {
        addSubview(userPortrait)
        addSubview(label)
    }
    
    private func activateConstraints() {
        
        userPortrait.snp.makeConstraints{ make in
            make.top.equalTo(5)
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints{ make in
            make.bottom.equalTo(-5)
            make.width.equalTo(75)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
    }
}

class CustomRemoteInfo {
    var volume: UInt?
    var quality: TRTCQuality?
}

class AudioCallingViewController : UIViewController {
    
    let navgationTitle: String = Localize("TRTC-API-Example.AudioCalling.Title")
    var roomId: UInt32 = 0
    var userId: String = ""
    let maxRemoteUserNum = 6
    let SDKAppID: UInt32 = 0

    let userBox1: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    let userBox2: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    let userBox3: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    let userBox4: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    let userBox5: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    let userBox6: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    lazy var userIdArray: [String] = {
        var array = [String]()
        return array
    }()
    
    let stackView1: UIStackView = {
        var view = UIStackView(frame: .zero)
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 30
        return view
    }()
    
    let stackView2: UIStackView = {
        var view = UIStackView(frame: .zero)
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 30
        return view
    }()
    
    let userStatusTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .gray
        return tableView
    }()
    
    let hansFreeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localize("TRTC-API-Example.AudioCalling.speaker"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.AudioCalling.earPhone"), for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)

        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let muteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localize("TRTC-API-Example.AudioCalling.mute"), for: .normal)
        button.setTitle(Localize("TRTC-API-Example.AudioCalling.cancelMute"), for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    let hangUpButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle(Localize("TRTC-API-Example.AudioCalling.hangup"), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 15.0)

        return button
    }()
    
    let dashBoardLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Localize("TRTC-API-Example.AudioCalling.dashBorad")
        label.textColor =  UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var userBoxArray: [UserBox] = {
        return [userBox1, userBox2, userBox3, userBox4, userBox5, userBox6]
    }()
    
    let trtcCloud: TRTCCloud = {
        return TRTCCloud.sharedInstance()
    }()
    
    lazy var remoteInfoDictionary: [String: CustomRemoteInfo] = {
        var dic = [String: CustomRemoteInfo]()
        return dic
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        trtcCloud.delegate = self
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        setupTRTCCloud()
        
        navigationItem.title = navgationTitle + "\(roomId)"
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func onSwitchSpeakerClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            trtcCloud.getDeviceManager().setAudioRoute(.speakerphone)
        } else {
            trtcCloud.getDeviceManager().setAudioRoute(.earpiece)
        }
    }
    
    @objc func onMicCaptureClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            trtcCloud.muteLocalAudio(true)
        } else {
            trtcCloud.muteLocalAudio(false)
        }
    }
    
    @objc func onAudioCallStopClick(sender: UIButton) {
        trtcCloud.stopLocalAudio()
        navigationController?.popViewController(animated: true)
    }
    
    func setupTRTCCloud() {
        let params = TRTCParams()
        params.sdkAppId = UInt32(SDKAPPID)
        params.strRoomId = String(roomId)
        params.userId = userId as String
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId) as String

        self.trtcCloud.enterRoom(params, appScene: .videoCall)
        self.trtcCloud.startLocalAudio(.music)
        self.trtcCloud.enableAudioVolumeEvaluation(1000)
    }

    deinit {
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }

}

// MARK: - UI Layout
extension AudioCallingViewController {
    
    // Build view
    private func constructViewHierarchy() {
        view.addSubview(userStatusTableView)
        view.addSubview(hansFreeButton)
        view.addSubview(hangUpButton)
        view.addSubview(muteButton)
        view.addSubview(stackView2)
        view.addSubview(stackView1)
        for i in 0..<userBoxArray.count {
            if i/3 == 0 {
                stackView1.addArrangedSubview(userBoxArray[i])
            }
            else if i/3 == 1 {
                stackView2.addArrangedSubview(userBoxArray[i])
            }
        }
    }
    
    // view layout
    private func activateConstraints() {
        userStatusTableView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(200)
            make.top.equalTo(400)
            make.leading.equalTo(45)
        }
        
        hansFreeButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.leading.equalTo(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
            
        }
        
        hangUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.leading.equalTo(muteButton.snp.trailing).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        muteButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.leading.equalTo(hansFreeButton.snp.trailing).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        stackView1.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.width.equalTo(300)
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.width.equalTo(300)
            make.top.equalTo(195)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    // Binding events
    private func bindInteraction() {
        userStatusTableView.delegate = self
        userStatusTableView.dataSource = self
        userStatusTableView.allowsSelection = false
        hansFreeButton.addTarget(self, action: #selector(onSwitchSpeakerClick(sender: )), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(onMicCaptureClick(sender: )), for: .touchUpInside)
        hangUpButton.addTarget(self, action: #selector(onAudioCallStopClick(sender: )), for: .touchUpInside)
    }
}

// MARK: - UITableViewDataSource
extension AudioCallingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        cell.backgroundColor = UIColor.clear
        let userId = userIdArray[indexPath.row]
        if indexPath.section == 1 {
            guard let remoteInfo = remoteInfoDictionary[userId] else {
                return UITableViewCell()
            }
            guard let volume = remoteInfo.volume else {
                return UITableViewCell()
            }
            cell.textLabel?.text = userId + ":" + String(volume)
        }
        else if indexPath.section == 2 {
            var quality: String = ""
            switch remoteInfoDictionary[userId]?.quality {
            case .excellent:
                quality = "Best"
                break
            case .good:
                quality = "Good"
                break
            default:
                quality = "unknow"
            }
            cell.textLabel?.text =  userId + ":" + quality
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return dashBoardLabel.text
        }
        
        else if section == 1{
            return Localize("TRTC-API-Example.AudioCalling.volumInfo")
        }
        else{
            return Localize("TRTC-API-Example.AudioCalling.network")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return dashBoardLabel
        }

        let header: UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        header.textLabel?.textColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        return header
    }
    
}

// MARK: - UITableViewDelegate
extension AudioCallingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

//MARK: - TRTCCloudDelegate
extension AudioCallingViewController: TRTCCloudDelegate {
    
    func onRemoteUserEnterRoom(_ userId: String) {
        userIdArray.append(userId)
        remoteInfoDictionary[userId] = CustomRemoteInfo()
        refreshRemoteAudioViews()
    }
    
    func onRemoteUserLeaveRoom(_ userId: String, reason: Int) {
        guard let index = userIdArray.firstIndex(of: userId) else {
            return
        }
        userBoxArray[index].isHidden = true
        userIdArray.remove(at: index)
        remoteInfoDictionary.removeValue(forKey: userId)
        refreshRemoteAudioViews()
    }
    
    func refreshRemoteAudioViews() {
        for box in userBoxArray{
            box.isHidden = true
        }
        var index = 0
        for id in userIdArray {
            if index >= maxRemoteUserNum {
                return
            }
            userBoxArray[index].isHidden = false
            userBoxArray[index].label.text = id
            index += 1
        }
    }
    
    func onNetworkQuality(_ localQuality: TRTCQualityInfo, remoteQuality: [TRTCQualityInfo]) {
        for userId in userIdArray {
            for info in remoteQuality {
                if userId == info.userId {
                    remoteInfoDictionary[userId]?.quality = info.quality
                }
            }
        }
        userStatusTableView.reloadData()
    }
    
    func onUserVoiceVolume(_ userVolumes: [TRTCVolumeInfo], totalVolume: Int) {
        for userId in userIdArray {
            for info in userVolumes {
                if userId != info.userId {
                    remoteInfoDictionary[userId]?.volume = info.volume
                }
            }
        }
        userStatusTableView.reloadData()
    }
    
}



