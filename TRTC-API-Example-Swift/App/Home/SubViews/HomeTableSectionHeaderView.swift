//
//  HomeTableSectionHeaderView.swift
//  TRTC-API-Example-Swift
//
//  Created by peteryhchen on 2022/6/22.
//  Copyright © 2022 Tencent. All rights reserved.
//

import UIKit

class HomeTableSectionHeaderView : UITableViewHeaderFooterView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
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
        contentView.addSubview(titleLabel)
    }
    
    private func activateConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(10)
            make.trailing.bottom.equalTo(-10)
        }
    }
}
