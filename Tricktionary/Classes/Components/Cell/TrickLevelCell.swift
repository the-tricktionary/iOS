//
//  TrickLevelCell.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickLevelCell: BaseCell {
    
    // MARK: Variables
    
    fileprivate let view: UIView = UIView()
    fileprivate let topBorder: UIView = UIView()
    
    let title: UILabel = UILabel()
    
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
        contentView.addSubview(topBorder)
    }
    
    fileprivate func setup() {
        contentView.backgroundColor = Color.background
        
        
        view.backgroundColor = UIColor.white
        title.contentMode = .scaleAspectFill
        title.textAlignment = .left
        title.numberOfLines = 0
        
        selectionStyle = .none
        isUserInteractionEnabled = true
    }
    
    fileprivate func setupViewConstraints() {
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view).inset(10)
            make.right.equalTo(view)
            make.height.equalTo(view.snp.height)
        }
        
        topBorder.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.leading.equalTo(view).inset(1)
            make.trailing.equalTo(view).inset(1)
            make.height.equalTo(1)
        }
    }
    
    // MARK: Public
    
    func isTopBorderVisible(_ visible: Bool) {
        topBorder.isHidden = visible
    }
    
    func setupFont(bolt: Bool = false) {
        if bolt {
            title.font = UIFont.boldSystemFont(ofSize: 14)
            title.textColor = UIColor.black
        } else {
            title.font = UIFont.systemFont(ofSize: 14)
            title.textColor = UIColor.darkGray
        }
    }
    
    class func reuseIdentifier() -> String {
        return "cz.pixmo.tricktionary.TrickLevelCell"
    }
}
