//
//  UserCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 14/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    // MARK: Variables
    
    var view: UIView = UIView()
    var title: UILabel = UILabel()
    var icon: UIImageView = UIImageView()
    
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
        view.addSubview(icon)
    }
    
    fileprivate func setup() {
        
        contentView.backgroundColor = Color.background
        
        view.backgroundColor = Color.bar
        selectionStyle = .none
        
        icon.tintColor = UIColor.white
        icon.layer.cornerRadius = 30
        icon.clipsToBounds = true
        
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    fileprivate func setupViewConstraints() {
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(70)
        }
        
        icon.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.leading.equalTo(view).offset(5)
            make.centerY.equalTo(view)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.top)
            make.leading.equalTo(icon.snp.trailing).offset(5)
            make.trailing.equalTo(view).inset(5)
            make.centerY.equalTo(view)
        }
    }
    
}
