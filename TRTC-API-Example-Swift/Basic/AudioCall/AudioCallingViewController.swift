//
//  AudioCallingViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_TRTC

class UserBox: UIView {
    lazy var userPortrait: UIImageView = {
        var imageV = UIImageView()
        imageV.backgroundColor = .white
        return imageV
    }()
    
    lazy var label: UILabel = {
        var label = UILabel()
        label.backgroundColor = .blue
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
        backgroundColor = .red
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
    
    let hangUp: String = "挂断"
    let speaker: String = "使用扬声器"
    let earPhone: String = "使用听筒"
    let mute: String = "关闭麦克风"
    let cancelMute: String = "打开麦克风"
    let sectionTitle0: String = "信息面板"
    let sectionTitle1: String = "音量信息"
    let sectionTitle2: String = "网络信息"
    let navgationTitle: String = "房间号:"
    var roomId: UInt32 = 0
    var userId: String = ""
    let maxRemoteUserNum = 6
    let SDKAppID: UInt32 = 0

    lazy var userBox1: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    lazy var userBox2: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    lazy var userBox3: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    lazy var userBox4: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    lazy var userBox5: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    lazy var userBox6: UserBox = {
        var box = UserBox()
        box.isHidden = true
        return box
    }()
    
    lazy var userIdArray: [String] = {
        var array = [String]()
        return array
    }()
    
    lazy var stackView1: UIStackView = {
        var view = UIStackView(frame: .zero)
//        view.backgroundColor = .green
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 30
        return view
    }()
    
    lazy var stackView2: UIStackView = {
        var view = UIStackView(frame: .zero)
//        view.backgroundColor = .green
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 30
        return view
    }()
    
    lazy var userStatusTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .gray
        return tableView
    }()
    
    lazy var hansFreeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(speaker, for: .normal)
        button.setTitle(earPhone, for: .selected)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.addTarget(self, action: #selector(onSwitchSpeakerClick), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var muteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(mute, for: .normal)
        button.setTitle(cancelMute, for: .selected)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(onMicCaptureClick), for: .touchUpInside)
        return button
    }()
    
    lazy var hangUpButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle(hangUp, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(onAudioCallStopClick), for: .touchUpInside)
        return button
    }()
    
    lazy var dashBoardLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = sectionTitle0
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
        if sender.isSelected{
            trtcCloud.getDeviceManager().setAudioRoute(.speakerphone)
        }else{
            trtcCloud.getDeviceManager().setAudioRoute(.earpiece)
        }
    }
    
    @objc func onMicCaptureClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            trtcCloud.muteLocalAudio(true)
        }else{
            trtcCloud.muteLocalAudio(false)
        }
    }
    
    @objc func onAudioCallStopClick(sender: UIButton) {
        trtcCloud.stopLocalAudio()
        navigationController?.popViewController(animated: true)
    }
    
    func setupTRTCCloud() {
        let params = TRTCParams()
        params.sdkAppId = SDKAppID
        params.roomId = roomId
        params.userId = userId as String
        params.role = .anchor
        params.userSig = GenerateTestUserSig.genTestUserSig(identifier: params.userId)  as String

        self.trtcCloud.enterRoom(params, appScene: .videoCall)
        self.trtcCloud.startLocalAudio(.music)
        self.trtcCloud.enableAudioVolumeEvaluation(1000)
    }

    func dealloc() {
        trtcCloud.exitRoom()
        TRTCCloud.destroySharedIntance()
    }

}

// MARK: - UI Layout
extension AudioCallingViewController {
    
    //构建视图
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
    
    //视图布局
    private func activateConstraints() {
        userStatusTableView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(200)
            make.top.equalTo(400)
            make.leading.equalTo(45)
        }
        
        hansFreeButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.leading.equalTo(10)
            make.height.equalTo(35)
            
        }
        
        hangUpButton.snp.makeConstraints { make in
         
            make.bottom.equalTo(-40)
            make.leading.equalTo(210)
            make.width.equalTo(90)
            make.height.equalTo(35)
            
        }
        
        muteButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.leading.equalTo(110)
            make.height.equalTo(35)
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
    
    //绑定事件
    private func bindInteraction() {
        userStatusTableView.delegate = self
        userStatusTableView.dataSource = self
        userStatusTableView.allowsSelection = false
    }
}

// MARK: - UITableViewDataSource
extension AudioCallingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIdArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        cell.backgroundColor = UIColor.clear
        let userId = userIdArray[indexPath.row]
        if indexPath.section == 1 {
            let volume = remoteInfoDictionary[userId]?.volume
            cell.textLabel?.text = String(volume!)
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
            cell.textLabel?.text = quality
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return sectionTitle0
        }
        
        else if section == 1{
            return sectionTitle1
        }
        else{
            return sectionTitle2
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
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
        return 15;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
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
        let index = userIdArray.firstIndex(of: userId)
        userIdArray.remove(at: index!)
        userBoxArray[index!].isHidden = true
        remoteInfoDictionary.removeValue(forKey: userId)
        refreshRemoteAudioViews()
    }
    
    func refreshRemoteAudioViews() {
        for box in userBoxArray{
            box.isHidden = true
        }
        
        var index = 0;
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



