//
//  SpeedListCell.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 12/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SpeedListCell: UITableViewCell {
    
    // MARK: - Variables
    private let nameLabel = UILabel()
    private let missesLabel = UILabel()
    private let noMissScoreLabel = UILabel()
    private let scoreLabel = UILabel()
    private let separator = UIView()
    
    // MARK: - initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Content
    private func setupContent() {
        selectionStyle = .none
        separator.backgroundColor = .gray
        contentView.addSubview(separator)
        
        scoreLabel.textColor = Color.red
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        scoreLabel.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(scoreLabel)
        
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 2
        
        contentView.addSubview(container)
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        [missesLabel, noMissScoreLabel].forEach {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 13)
        }
        container.addArrangedSubview(nameLabel)
        container.addArrangedSubview(missesLabel)
        container.addArrangedSubview(noMissScoreLabel)
        
        contentView.backgroundColor = .white
        
        scoreLabel.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview().inset(15)
        }
        
        container.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(5)
            make.trailing.equalTo(scoreLabel.snp.leading).offset(-10)
        }
        
        separator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalTo(contentView.readableArea)
            make.height.equalTo(0.5)
        }
    }
    
    func customize(_ content: Content) {
        scoreLabel.text = "\(content.score)"
        nameLabel.text = content.name
        missesLabel.text = "Misses: \(content.misses)"
        noMissScoreLabel.text = "No miss score: \(content.noMissScore)"
    }
    
    class func reuseIdentifier() ->String {
        "cz.pixmo.tricktionary.SpeedListCell"
    }
}

extension SpeedListCell {
    struct Content: Hashable {
        
        let name: String
        let score: Int
        let misses: Int
        let noMissScore: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(score)
            hasher.combine(misses)
            hasher.combine(noMissScore)
        }
    }
}
