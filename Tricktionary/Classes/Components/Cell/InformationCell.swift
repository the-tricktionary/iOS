//
//  InformationCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 24/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class InformationCell: UITableViewCell {
    
    // MARK: Variables
    
    let title: UILabel = UILabel()
    let info: UILabel = UILabel()
    let view: UIView = UIView()
    
    
    // MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setup()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    fileprivate func setupSubviews() {
        contentView.addSubview(view)
        view.addSubview(title)
        view.addSubview(info)
    }
    
    fileprivate func setup() {
        isSkeletonable = true
        contentView.backgroundColor = UIColor.gray
        view.backgroundColor = UIColor.white
        view.isSkeletonable = true
        
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = UIColor.black
        title.isSkeletonable = true
        
        info.font = UIFont.systemFont(ofSize: 16)
        info.textColor = UIColor.black
        info.isSkeletonable = true
        
        selectionStyle = .none
    }
    
    fileprivate func setupViewConstraints() {
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(view).inset(16)
            make.top.equalTo(view).inset(5)
            make.bottom.equalTo(view).inset(5)
            make.right.equalTo(info.snp.left)
        }
        
        info.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right)
            make.right.equalTo(view).inset(10)
            make.top.equalTo(view).inset(5)
            make.bottom.equalTo(view).inset(5)
        }
    }
    
    struct Content {
        let title: String
        let info: String
    }
}

