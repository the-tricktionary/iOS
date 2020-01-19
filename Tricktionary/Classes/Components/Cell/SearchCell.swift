//
//  SearchCell.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 19/01/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SearchCell: BaseCell {

    // MARK: - Variables
    private let name = UILabel()
    private let level = UILabel()
    private let levels = UILabel()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content
    private func setupContent() {
        contentView.addSubview(name)
        contentView.addSubview(level)
        contentView.addSubview(levels)

        name.font = UIFont.systemFont(ofSize: 17)
        name.textColor = .black

        level.font = UIFont.systemFont(ofSize: 14)
        level.textColor = .gray
        level.textAlignment = .right

        levels.font = UIFont.systemFont(ofSize: 12)
        levels.textColor = .red

        name.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(contentView).inset(10)
        }

        levels.snp.makeConstraints { (make) in
            make.leading.equalTo(name)
            make.top.equalTo(name.snp.bottom).inset(5)
            make.bottom.equalTo(contentView).offset(-10)
        }

        level.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-16)
            make.leading.equalTo(name.snp.trailing)
            make.centerY.equalTo(contentView)
        }
    }

    func customize(with name: String, level: String, levels: String) {
        self.name.text = name
        self.level.text = level
        self.levels.text = levels
    }
}
