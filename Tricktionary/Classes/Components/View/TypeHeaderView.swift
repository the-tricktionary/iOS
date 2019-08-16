//
//  TypeHeaderView.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TypeHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Variables
    
    let title: UILabel = UILabel()
    
    // MARK: Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupViewsStyle()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func setTitleLabel(_ titleLabel: String?) {
        title.text = titleLabel?.uppercased()
    }
    
    // MARK: Privates
    
    private func setupSubViews() {
        addSubview(title)
    }
    
    private func setupViewsStyle() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor(red: 254/255, green: 197/255, blue: 0/255, alpha: 1.0)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .black
        title.textAlignment = .justified
    }
    
    private func setupViewConstraints() {
        title.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(10)
            make.centerY.equalTo(self)
        }
        
        backgroundView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
    
}
