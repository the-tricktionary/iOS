//
//  SpeedEventCell.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 12/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SpeedEventCell: UITableViewCell {
    
    // MARK: - Variables
    private let nameLabel = UILabel()
    var content: Content?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Content
    private func setupContent() {
        let container = UIView()
        container.backgroundColor = Color.red
        container.layer.cornerRadius = 5
        container.layer.borderWidth = 1
        container.layer.borderColor = Color.red.cgColor
        container.clipsToBounds = false
        
        contentView.addSubview(container)
        container.addSubview(nameLabel)
        
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        
        selectionStyle = .none
        
        container.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func customize(content: Content) {
        self.content = content
        nameLabel.text = content.name
    }
    
    class func reuseIdentifier() -> String {
        "cz.pixmo.tricktionary.SpeedEventCell"
    }
}

extension SpeedEventCell {
    struct Content {
        let name: String
//        let periods: Int
//        let checkpoints: Int
    }
}
