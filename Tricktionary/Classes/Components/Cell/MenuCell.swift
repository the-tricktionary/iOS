//
//  MenuCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UITableViewCell {
    
    // MARK: Variables
    
    var view: UIView = UIView()
    var title: UILabel = UILabel()
    var itemDescription: UILabel = UILabel()
    var icon: UIImageView = UIImageView()
    
    fileprivate let topBorder: UIView = UIView()
    
    // MARK: Life cycles
    
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
        view.addSubview(itemDescription)
        view.addSubview(icon)
        contentView.addSubview(topBorder)
    }
    
    fileprivate func setup() {
        selectionStyle = .none
        
        icon.tintColor = UIColor.black
        
        topBorder.backgroundColor = UIColor.clear
        
        title.textColor = UIColor.black
        title.font = UIFont.boldSystemFont(ofSize: 16)
        
        itemDescription.textColor = UIColor.black
        itemDescription.font = UIFont.systemFont(ofSize: 12)
    }
    
    fileprivate func setupViewConstraints() {
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        icon.snp.makeConstraints { (make) in
            make.size.equalTo(37)
            make.leading.equalTo(view).offset(5)
            make.centerY.equalTo(view)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.top)
            make.leading.equalTo(icon.snp.trailing).offset(5)
            make.trailing.equalTo(view).inset(5)
            make.height.equalTo(20)
        }
        
        itemDescription.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(2)
            make.leading.equalTo(title)
            make.trailing.equalTo(view).inset(5)
            make.height.equalTo(15)
        }
        
        topBorder.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
    }
    
    // MARK: Public
    
    func removeDescription() {
        
        title.snp.remakeConstraints { (make) in
            make.top.equalTo(icon)
            make.leading.equalTo(icon.snp.trailing).offset(5)
            make.trailing.equalTo(view).inset(5)
            make.centerY.equalTo(view)
        }
        
        itemDescription.snp.removeConstraints()
    }
    
}
