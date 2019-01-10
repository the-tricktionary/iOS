//
//  MenuItemView.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 10/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class MenuItemView: UIView {
    
    // MARK: Variables
    
    let title: UILabel = UILabel()
    
    // MARK: Life cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupViewConstraints()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
        setupViewConstraints()
        setup()
    }
    
    // MARK: Privates
    
    fileprivate func setupSubviews() {
        self.addSubview(title)
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.orange
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    fileprivate func setupViewConstraints() {
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
