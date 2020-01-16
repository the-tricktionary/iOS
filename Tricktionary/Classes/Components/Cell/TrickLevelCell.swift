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
    
    private let view = UIView()
    private let title = UILabel()
    private lazy var descriptionLabel = LevelView()
    private let accesoryView = UIImageView()
    
    // MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Privates
    
    private func setupContent() {
        view.backgroundColor = UIColor.white
        title.contentMode = .scaleAspectFill
        title.textAlignment = .left
        title.numberOfLines = 0

        selectionStyle = .none
        isUserInteractionEnabled = true

        contentView.backgroundColor = Color.background
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .center

        view.addSubview(stackView)
        view.addSubview(accesoryView)
        contentView.addSubview(view)

        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(descriptionLabel)

        view.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }

        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().offset(-40)
        }

        accesoryView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(stackView.snp.trailing)
            make.width.equalTo(27)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }

    }
    
    // MARK: Public

    func customize(with model: Content) {
        title.text = model.title
        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.customize(with: model.description)
        accesoryView.image = model.isDone ? UIImage(named: "done") : nil
    }
    
    class func reuseIdentifier() -> String {
        return "cz.pixmo.tricktionary.TrickLevelCell"
    }
}

class LevelView: UIView {
    // MARK: - Variables
    private let icon = UIImageView()
    private let descriptionLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MAKR: - Content
    private func setupContent() {
        addSubview(icon)
        addSubview(descriptionLabel)
        icon.image = UIImage(named: "ijru")
        descriptionLabel.font = UIFont(name: "Helvetica", size: 12)
        descriptionLabel.textColor = .red

        icon.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(16)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    func customize(with description: String?) {
        descriptionLabel.text = description
    }

}

extension TrickLevelCell {
    struct Content {
        var title: String
        var description: String?
        var isDone: Bool
    }
}

