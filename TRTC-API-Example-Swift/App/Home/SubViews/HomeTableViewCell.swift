//
//  HomeTableViewCell.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/22.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 52.0/255, green: 184.0/255, blue: 97.0/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
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
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
    }
    
    private func activateConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(10)
            make.trailing.bottom.equalTo(-10)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(10)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
    
}
