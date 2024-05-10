//
//  PushCDNSelectRoleViewController.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/7/13.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit

/*
 CDN Publishing - Audience
 TRTC CDN Publishing
 This document shows how to integrate the CDN publishing feature.
 1. audience is the audience,click to enter:PushCDNAudienceViewController(Audience example)
 2. anchor is the anchor,click to enter:PushCDNAnchorViewController(Anchor example)
 Documentation: https://cloud.tencent.com/document/product/647/16827
 */

class PushCDNSelectRoleViewController: UIViewController {
    
    let nextStepButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.setTitle(Localize("TRTC-API-Example.PushCDN.NextStep"), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let anchorButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle(Localize("TRTC-API-Example.PushCDN.AnchorStart"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        button.layer.cornerRadius = 60
        button.layer.masksToBounds = true
        return button
    }()

    let audienceButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle(Localize("TRTC-API-Example.PushCDN.AudienceStart"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 60
        button.layer.masksToBounds = true
        return button
    }()
    
    let tipsLable: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.text = Localize("TRTC-API-Example.PushCDN.TipsTitle")
        return label
    }()
    
    let tipItemOneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.text = Localize("TRTC-API-Example.PushCDN.TipsOne")
        return label
    }()
    
    let tipItemTowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = Localize("TRTC-API-Example.PushCDN.TipsTwo")
        return label
    }()
    
    let tipItemThreeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.text = Localize("TRTC-API-Example.PushCDN.TipsThree")
        return label
    }()
    
    let tipsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 14.0)
        textView.isSelectable = true
        textView.dataDetectorTypes = .link
        textView.text = Localize("TRTC-API-Example.PushCDN.TipsURL")
        textView.setContentOffset(CGPoint.zero, animated: false)
        return textView
    }()
    
    lazy var userType: UserType = {
        let userType = UserType.anchor
        return userType
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = "Pubish via CDN"
    }
    
}

extension PushCDNSelectRoleViewController {
    
    func setUserType(userType: UserType) {
        self.userType = userType
        switch userType {
        case .anchor:
            audienceButton.backgroundColor = .gray
            anchorButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        case .audience:
            audienceButton.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
            anchorButton.backgroundColor = .gray
        }
    }
    
    @objc func onAudienceClick(sender: UIButton) {
        setUserType(userType: .audience)
    }
    
    @objc func onAnchorClick(sender: UIButton) {
        setUserType(userType: .anchor)
    }
    
    @objc func onNextStepClick(sender: UIButton) {
        switch userType {
        case .anchor:
            let anchorVC = PushCDNAnchorViewController()
            navigationController?.pushViewController(anchorVC, animated: true)
            break
            
        case .audience:
            let audienceVC = PushCDNAudienceViewController()
            navigationController?.pushViewController(audienceVC, animated: true)
            break
        }
    }
}

//MARK: - UI Layout
extension PushCDNSelectRoleViewController {
    
    // Build view
    private func constructViewHierarchy() {
        view.addSubview(nextStepButton)
        view.addSubview(anchorButton)
        view.addSubview(audienceButton)
        view.addSubview(tipsLable)
        view.addSubview(tipItemOneLabel)
        view.addSubview(tipItemTowLabel)
        view.addSubview(tipItemThreeLabel)
        view.addSubview(tipsTextView)
    }
    
    // view layout
    private func activateConstraints() {
        
        tipsLable.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(130)
            
        }
        
        tipItemOneLabel.snp.makeConstraints { make in
            make.left.equalTo(tipsLable)
            make.top.equalTo(tipsLable.snp.bottom)
            make.width.equalTo(350)
        }
        
        tipItemTowLabel.snp.makeConstraints { make in
            make.left.equalTo(tipItemOneLabel)
            make.top.equalTo(tipItemOneLabel.snp.bottom)
            make.width.equalTo(tipItemOneLabel)
        }
        
        tipItemThreeLabel.snp.makeConstraints { make in
            make.left.equalTo(tipItemOneLabel)
            make.top.equalTo(tipItemTowLabel.snp.bottom)
            make.width.equalTo(tipItemOneLabel)
        }
        
        anchorButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.left.equalTo(nextStepButton.snp.left).offset(20)
            make.top.equalTo(tipItemThreeLabel.snp.bottom).offset(70)
            
        }
        
        audienceButton.snp.makeConstraints { make in
            make.right.equalTo(nextStepButton.snp.right).offset(-20)
            make.height.equalTo(anchorButton)
            make.width.equalTo(anchorButton)
            make.top.equalTo(anchorButton)
        }
        
        tipsTextView.snp.makeConstraints { make in
            make.top.equalTo(anchorButton.snp.bottom).offset(80)
            make.width.equalTo(350)
            make.height.equalTo(150)
            make.left.equalTo(tipsLable)
        }

        nextStepButton.snp.makeConstraints { make in
            make.left.equalTo(tipsLable)
            make.top.equalTo(tipsTextView.snp.bottom).offset(40)
            make.width.equalTo(350)
            make.height.equalTo(45)
        }
        
    }
    
    // Binding events/callbacks
    private func bindInteraction() {
        anchorButton.addTarget(self, action: #selector(onAnchorClick(sender: )), for: .touchUpInside)
        audienceButton.addTarget(self, action: #selector(onAudienceClick(sender: )), for: .touchUpInside)
        nextStepButton.addTarget(self, action: #selector(onNextStepClick(sender: )), for: .touchUpInside)
    }
}
