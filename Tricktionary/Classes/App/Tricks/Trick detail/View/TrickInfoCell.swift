//
//  TrickInfoCell.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 18/03/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickInfoCell: UITableViewCell {

    // MARK: - Variables
    // public

    // private
    private let name = UILabel()
    private let level = UILabel()
    private let favorite = UIButton()
    private let completed = UIButton()

    // MARK: - Initializers
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
        name.font = UIFont.systemFont(ofSize: 16)

        level.textColor = .red
        level.font = UIFont.systemFont(ofSize: 16)

        favorite.setImage(UIImage(named: "favorite"), for: .normal)

        completed.setImage(UIImage(named: "done"), for: .normal)

        contentView.addSubview(name)
        contentView.addSubview(level)
        contentView.addSubview(favorite)
        contentView.addSubview(completed)

        setupConstraints()
    }

    private func setupConstraints() {
        name.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(77)
        }

        level.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(15)
            make.leading.equalTo(name)
            make.width.equalTo(name)
            make.bottom.equalToSuperview().offset(-16)
        }

        completed.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(25)
        }

        favorite.snp.makeConstraints { (make) in
            make.trailing.equalTo(completed.snp.leading).offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }

    func customize(with content: Content) {
        self.name.text = content.name
        let ijruImage = NSTextAttachment()
        ijruImage.image = UIImage(named: "ijru")
        ijruImage.bounds = CGRect(x: 0.0,
                                  y: -9,
                                  width: ijruImage.image!.size.width,
                                  height: ijruImage.image!.size.height)
        let ijruText = NSMutableAttributedString(attachment: ijruImage)
        ijruText.insert(NSAttributedString(string: "      " + content.level,
                                           attributes: [NSAttributedString.Key.foregroundColor : UIColor.red]),
                                           at: ijruText.length)

        self.level.attributedText = ijruText
        self.favorite.setImage(content.favorite ? UIImage(named: "favorite") : UIImage(named: "favorite-outline"), for: .normal)
        self.completed.setImage(content.completed ? UIImage(named: "done") : UIImage(named: "done-outline"), for: .normal)
    }
}

extension TrickInfoCell {
    struct Content {
        var name: String
        var level: String
        var favorite: Bool
        var completed: Bool
    }
}
