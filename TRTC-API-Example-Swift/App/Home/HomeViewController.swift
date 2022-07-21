//
//  ViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/17.
//

import UIKit
import SnapKit

enum TRTCAPIItem: String {
    case voiceCall = "语音通话"
    case videoCall = "视频通话"
    case liveVideo = "视频互动直播"
    case liveAudio = "语音互动直播"
    case screenRecording = "录屏直播"
    case stringRoomId = "字符串房间号"
    case videoQuality = "画质设定"
    case soundQuality = "音质设定"
    case renderParams = "渲染控制"
    case speedTest = "网络测速"
    case pushCDN = "CDN发布"
    case customCamera = "自定义视频采集&渲染"
    case soundEffects = "设置音效"
    case setBGM = "设置背景音乐"
    case localVideoShare = "本地视频分享"
    case localRecord = "本地媒体录制"
    case joinMultipleRoom = "加入多个房间"
    case sendReceiveSEIMessage = "收发SEI消息"
    case quicklySwitchRooms = "快速切换房间"
    case roomPK = "跨房PK"
    case thirdBeauty = "第三方美颜"
    
}

enum SectionTitle: String{
    case section1 = "基础功能"
    case section2 = "进阶功能"
}

class HomeViewController: UIViewController {

    let CellReuseId: String = "Cell_ID"
    let CellHeaderId: String = "Header_ID"
    
    lazy var basicDataSource: [TRTCAPIItem] = {
        return [.voiceCall, .videoCall, .liveVideo, .liveAudio,.screenRecording]
    }()
    
    lazy var advancedDataSource: [TRTCAPIItem] = {
//        return [.stringRoomId,
//                .videoQuality,
//                .soundQuality,
//                .renderParams,
//                .speedTest,
//                .pushCDN,
//                .customCamera,
//                .soundEffects,
//                .setBGM,
//                .localVideoShare,
//                .localRecord,
//                .joinMultipleRoom,
//                .sendReceiveSEIMessage,
//                .quicklySwitchRooms,
//                .roomPK,
//                .thirdBeauty]
//    }()
        
        return [
                .setBGM,
                .localRecord,
                .roomPK,
                .speedTest,
                .stringRoomId,
                .quicklySwitchRooms,
                .renderParams,
                .soundQuality,
                .customCamera,
                .soundEffects,
                .joinMultipleRoom,
                .sendReceiveSEIMessage,
        ]
    }()
    
    lazy var sectionTitle: [SectionTitle] = {
        return [.section1, .section2]
    }()

    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .black
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: CellReuseId)
        view.register(HomeTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CellHeaderId)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
    }
    
}

// MARK: - UI Layout
extension HomeViewController {
    
    // 构建视图
    private func constructViewHierarchy() {
        view.addSubview(tableView)
    }
    
    // 视图布局
    private func activateConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 绑定事件 / 回调
    private func bindInteraction() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return basicDataSource.count
        }
        return advancedDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId, for: indexPath) as! HomeTableViewCell
        if indexPath.section == 0{
            cell.titleLabel.text = basicDataSource[indexPath.row].rawValue
        }
        else{
            cell.titleLabel.text = advancedDataSource[indexPath.row].rawValue
        }
        return cell
        
    }
    
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{

                let controller = AudioCallingEnterViewController()
                navigationController?.pushViewController( controller, animated: true)
            }
            if indexPath.row == 1{
                let controll = VideoCallingEnterViewController()
                navigationController?.pushViewController( controll, animated: true)
            }
            if indexPath.row == 2{
                let controller = LiveEnterViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 3{
                let controller = VoiceChatRoomEnterViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 4{
                let controller = ScreenEntranceViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            
            
        }
        
        if indexPath.section == 1{
//            if indexPath.row == 0{
//                let controller = StringRoomIdViewController()
//                navigationController?.pushViewController(controller, animated: true)
//            }
            if indexPath.row == 0{
                let controller = SetBGMViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 1{
                let controller = LocalRecordViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 2{
                let controller = RoomPkViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 3{
                let controller = SpeedTestViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 4{
                let controller = StringRoomIdViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 5{
                let controller = SwitchRoomViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 6{
                let controller = SetRenderParamsViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 7{
                let controller = SetAudioQualityViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 8{
                let controller = CustomCaptureViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 9{
                let controller = SetAudioEffectViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 10{
                let controller = JoinMultipleRoomViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 11{
                let controller = SendAndReceiveSEIMessageViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellHeaderId) as! HomeTableSectionHeaderView
        headerView.titleLabel.text = sectionTitle[section].rawValue
        return headerView.titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}
