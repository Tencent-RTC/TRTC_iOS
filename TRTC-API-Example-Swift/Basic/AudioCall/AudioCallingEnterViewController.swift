//
//  AudioCallingEnterViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import SnapKit

class AudioCallingEnterViewController: UIViewController{
    let roomTitle: String = "TRTC 语音通话示例"
    let inputRoomNumberText: String = "请输入房间号(必填项)"
    let inputUserNameText: String = "请输入用户名(必填项)"
    let buttomTitle: String = "进入房间"
    
    lazy var userIdTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .white
        textField.text = String(arc4random() % (9999999 - 1000000 + 1) + 1000000)
        return textField
    }()
    
    lazy var roomIdTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .white
        textField.text = String(arc4random() % (999999 - 100000 + 1) + 100000)
        return textField
    }()
    
    lazy var inputRoomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = inputRoomNumberText
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var inputUserLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = inputUserNameText
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        button.setTitle(buttomTitle, for: UIControl.State.normal)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(OnStartClick), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()

        navigationItem.title = roomTitle
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func OnStartClick(){
        let audioCallingViewController = AudioCallingViewController()
        navigationController?.pushViewController(audioCallingViewController, animated: true)
    }
    
}

//MARK: - UI Layout
extension AudioCallingEnterViewController{
    
    // 构建视图
    private func constructViewHierarchy() {
        view.addSubview(inputRoomLabel)
        view.addSubview(roomIdTextField)
        view.addSubview(inputUserLabel)
        view.addSubview(userIdTextField)
        view.addSubview(startButton)
    }
    
    // 视图布局
    private func activateConstraints() {
        userIdTextField.snp.makeConstraints { make in
            make.top.equalTo(280)
            make.leading.equalTo(50)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        inputUserLabel.snp.makeConstraints{ make in
            make.top.equalTo(250)
            make.leading.equalTo(50)
        }
        startButton.snp.makeConstraints{ make in
            make.leading.equalTo(50)
            make.bottom.equalTo(-150)
            make.width.equalTo(300)
        }
        
        inputRoomLabel.snp.makeConstraints{ make in
            make.top.equalTo(150)
            make.leading.equalTo(50)
        
        }
        
        roomIdTextField.snp.makeConstraints{ make in
            make.top.equalTo(180)
            make.leading.equalTo(50)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
    }
    
    // 绑定事件 / 回调
    private func bindInteraction() {
        
    }
    
}


