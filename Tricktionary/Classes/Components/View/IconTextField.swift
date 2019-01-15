//
//  IconTextField.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 15/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class IconTextField: UIView {
    
    // MARK: Variables
    
    let foregroundColor = UIColor(red: 146/255 , green: 146/255, blue: 146/255, alpha: 1.0)
    let textField = UITextField()
    let icon = UIImageView()
    let warningFormat = UILabel()
    
    // MARK: Life cycles
    
    required init() {
        super.init(frame: .zero)
        setupSubviews()
        setUpPlaceholder()
        setupViewConstraints()
        
        warningFormat.textColor = .red
        warningFormat.font = UIFont.systemFont(ofSize: 12)
        
        icon.tintColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    fileprivate func setupSubviews() {
        self.addSubview(textField)
        self.addSubview(icon)
        self.addSubview(warningFormat)
    }
    
    fileprivate func setupViewConstraints() {
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top)
            make.size.equalTo(30)
        }
        
        textField.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.left.equalTo(icon.snp.right).offset(16)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(30)
        }
        
        warningFormat.snp.makeConstraints { (make) in
            make.right.equalTo(textField.snp.right)
            make.top.equalTo(textField.snp.bottom).offset(3)
        }
    }
    
    fileprivate func setUpPlaceholder() {
        textField.backgroundColor = .white
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: foregroundColor,
                                                                                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor(red: 205/255, green: 209/255, blue: 212/255, alpha: 1.0).cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius = 0.0
    }
}
