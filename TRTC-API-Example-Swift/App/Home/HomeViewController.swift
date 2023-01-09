//
//  ViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/17.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    let CellReuseId: String = "Cell_ID"
    let CellHeaderId: String = "Header_ID"
    
    let basicDataSource: [String] = {
        return [
            Localize("TRTC-API-Example.Home.VoiceCalls"),
            Localize("TRTC-API-Example.Home.VideoCalls"),
            Localize("TRTC-API-Example.Home.VideoLive"),
            Localize("TRTC-API-Example.Home.TalkingRoom"),
            Localize("TRTC-API-Example.Home.LiveScreen"),]
    }()
    
    let advancedDataSource: [String] = {
        return [
            Localize("TRTC-API-Example.Home.StringRoomId"),
            Localize("TRTC-API-Example.Home.VideoQuality"),
            Localize("TRTC-API-Example.Home.SoundQuality"),
            Localize("TRTC-API-Example.Home.RenderParams"),
            Localize("TRTC-API-Example.Home.SpeedTest"),
            Localize("TRTC-API-Example.Home.PushCDN"),
            Localize("TRTC-API-Example.Home.CustomCamera"),
            Localize("TRTC-API-Example.Home.SoundEffects"),
            Localize("TRTC-API-Example.Home.SetBGM"),
            Localize("TRTC-API-Example.Home.LocalRecord"),
            Localize("TRTC-API-Example.Home.JoinMultipleRoom"),
            Localize("TRTC-API-Example.Home.SendReceiveSEIMessage"),
            Localize("TRTC-API-Example.Home.QuicklySwitchRooms"),
            Localize("TRTC-API-Example.Home.RoomPK"),
            Localize("TRTC-API-Example.Home.PictureInPicture"),]
    }()
    
    let sectionTitle: [String] = {
        return [
            Localize("TRTC-API-Example.Home.BasicFunctions"),
            Localize("TRTC-API-Example.Home.AdvancedFeatures"),]
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
        if indexPath.section == 0 {
            cell.titleLabel.text = basicDataSource[indexPath.row]
        }
        else {
            cell.titleLabel.text = advancedDataSource[indexPath.row]
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let controller = AudioCallingEnterViewController()
                navigationController?.pushViewController( controller, animated: true)
            }
            if indexPath.row == 1 {
                let controll = VideoCallingEnterViewController()
                navigationController?.pushViewController( controll, animated: true)
            }
            if indexPath.row == 2 {
                let controller = LiveEnterViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 3 {
                let controller = VoiceChatRoomEnterViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 4 {
                let controller = ScreenEntranceViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let controller = StringRoomIdViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 1 {
                let controller = SetVideoQualityViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 2 {
                let controller = SetAudioQualityViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 3 {
                let controller = SetRenderParamsViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 4 {
                let controller = SpeedTestViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 5 {
                let controller = PushCDNSelectRoleViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 6 {
                let controller = CustomCaptureViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 7 {
                let controller = SetAudioEffectViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 8 {
                let controller = SetBGMViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 9 {
                let controller = LocalRecordViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 10 {
                let controller = JoinMultipleRoomViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 11 {
                let controller = SendAndReceiveSEIMessageViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 12 {
                let controller = SwitchRoomViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 13 {
                let controller = RoomPkViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            if indexPath.row == 14 {
                let controller = PictureInPictureViewController()
                navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellHeaderId) as! HomeTableSectionHeaderView
        headerView.titleLabel.text = sectionTitle[section]
        return headerView.titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}
