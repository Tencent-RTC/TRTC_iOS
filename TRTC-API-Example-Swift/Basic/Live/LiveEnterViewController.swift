//
//  LiveEnterViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by 唐佳宁 on 2022/6/30.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import UIKit
class LiveEnterViewController:UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = Localize("TRTC-API-Example.Live.EnterRoomNumber")
        enterRoomTextField.delegate = self
        enterUserNameTextField.delegate = self
        setupDefaultUIConfig()
        activateConstraints()
        bindInteraction()
        userType = .Anchor
    }
    
    var userType : UserType = .Anchor

    let enterRoomLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.Live.EnterRoomNumber")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let enterUserNameLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.Live.EnterUserName")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let userIdentifyLabel:UILabel={
        let lable = UILabel(frame: .zero)
        lable.textColor = .white
        lable.text = Localize("TRTC-API-Example.Live.ChooseUserIdentify")
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let enterRoomTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = "1256732"
        filed.textColor = .white
        filed.backgroundColor = .green
        filed.returnKeyType = .done
        return filed
    }()
    
    let enterUserNameTextField : UITextField={
        let filed = UITextField(frame: .zero)
        filed.keyboardAppearance = .default
        filed.text = "324532"
        filed.textColor = .white
        filed.backgroundColor = .green
        filed.returnKeyType = .done
        return filed
    }()
    
    let anchorButton: UIButton={
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.Live.Anchor"), for: .normal)
        button.backgroundColor = .themeTintColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let audienceButton: UIButton={
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.Live.Audience"), for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let enterRoomButton: UIButton={
        let button = UIButton(frame: .zero)
        button.setTitle(Localize("TRTC-API-Example.Live.EnterRoom"), for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(clickEnterRoomButton), for: .touchUpInside)
        return button
    }()
    
    
}


extension LiveEnterViewController{
    
    private func setupDefaultUIConfig(){
        view.addSubview(enterRoomLabel)
        view.addSubview(enterUserNameLabel)
        view.addSubview(userIdentifyLabel)
        view.addSubview(enterRoomTextField)
        view.addSubview(enterUserNameTextField)
        view.addSubview(anchorButton)
        view.addSubview(audienceButton)
        view.addSubview(enterRoomButton)
    }
    
    private func activateConstraints(){
        enterRoomLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(39)
            make.top.equalTo(114)
            make.left.equalTo(20)
        }
        
        enterRoomTextField.snp.makeConstraints { make in
            make.width.equalTo(374)
            make.height.equalTo(34)
            make.top.equalTo(enterRoomLabel.snp.bottom).offset(5)
            make.left.equalTo(enterRoomLabel)
        }
        
        enterUserNameLabel.snp.makeConstraints { make in
            make.width.equalTo(enterRoomLabel)
            make.height.equalTo(enterRoomLabel)
            make.top.equalTo(enterRoomTextField.snp.bottom).offset(5)
            make.left.equalTo(enterRoomTextField)
        }
        
        enterUserNameTextField.snp.makeConstraints { make in
            make.width.equalTo(enterRoomTextField)
            make.height.equalTo(enterRoomTextField)
            make.top.equalTo(enterUserNameLabel.snp.bottom).offset(5)
            make.left.equalTo(enterUserNameLabel)
        }
        
        userIdentifyLabel.snp.makeConstraints { make in
            make.width.equalTo(enterUserNameLabel)
            make.height.equalTo(enterUserNameLabel)
            make.top.equalTo(enterUserNameTextField.snp.bottom).offset(5)
            make.centerX.equalTo(enterUserNameTextField)
        }
        
        anchorButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.top.equalTo(userIdentifyLabel.snp.bottom).offset(5)
            make.left.equalTo(userIdentifyLabel)
        }
        
        audienceButton.snp.makeConstraints { make in
            make.width.equalTo(anchorButton)
            make.height.equalTo(anchorButton)
            make.top.equalTo(anchorButton)
            make.left.equalTo(anchorButton.snp.right).offset(25)
        }
        
        enterRoomButton.snp.makeConstraints { make in
            make.width.equalTo(205)
            make.height.equalTo(39)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.centerX.equalTo(view)
        }
        
    }
    private func bindInteraction(){
           anchorButton.addTarget(self, action: #selector(clickAnchorButton), for: .touchUpInside)
           audienceButton.addTarget(self, action: #selector(clickAudienceButton), for: .touchUpInside)
     }
    
}

extension LiveEnterViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterRoomTextField.resignFirstResponder()
        return enterUserNameTextField.resignFirstResponder()
    }
    
    @objc private func clickAnchorButton(){
        userType = .Anchor
        audienceButton.backgroundColor = .gray
        anchorButton.backgroundColor = .green
    }
    
    @objc private func clickAudienceButton(){
        userType = .Audience
        audienceButton.backgroundColor = .green
        anchorButton.backgroundColor = .gray
    }
    
    @objc func clickEnterRoomButton() {
        if enterRoomTextField.text?.count==0 || enterUserNameTextField.text?.count == 0{
            showAlertViewController(title: Localize("TRTC-API-Example.AlertViewController.ponit"), message: Localize("TRTC-API-Example.Live.tips"))
        }
        let roomId = (enterRoomTextField.text! as NSString).integerValue
        let userId = enterUserNameTextField.text
        switch userType{
        case .Anchor:
            let anchorVC = LiveAnchorViewController().initWithRoomId(roomId: roomId, userId: userId ?? "")
            anchorVC.title = Localize("TRTC-API-Example.LiveAnchor.Title")
            navigationController?.pushViewController(anchorVC, animated: true)
            break
            
            
        case .Audience:
            let audienceVC = LiveAudienceViewController().initWithRoomId(roomId: roomId, userId: userId ?? "")
            audienceVC.title = Localize("TRTC-API-Example.LiveAudience.Title")
            navigationController?.pushViewController(audienceVC, animated: true)
            
            break
        default:
            break
        }
    }
    
    func showAlertViewController(title:String,message:String){
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Localize("TRTC-API-Example.AlertViewController.determine"), style: .default)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        enterRoomTextField.resignFirstResponder()
        enterUserNameTextField.resignFirstResponder()
    }
    
}
