//
//  DescriptionCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 24/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class DescriptionCell: UITableViewCell {
    
    // MARK: Variables
    
    let descriptionText: UILabel = UILabel()
    
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
        contentView.addSubview(descriptionText)
    }
    
    fileprivate func setup() {
        contentView.backgroundColor = Color.background
        
        descriptionText.font = UIFont.systemFont(ofSize: 16)
        descriptionText.textColor = UIColor.black
        descriptionText.numberOfLines = 0
        descriptionText.isSkeletonable = true
        
        isSkeletonable = true
        
        selectionStyle = .none
    }
    
    fileprivate func setupViewConstraints() {
        
        descriptionText.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(5)
            make.leading.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView).inset(5)
        }
    }
}


