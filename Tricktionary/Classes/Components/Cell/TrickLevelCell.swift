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
    private let ijruLevel = LevelView()
    private lazy var irsfLevel = LevelView()
    private lazy var wjrLevel = LevelView()
    private let levelsContainer = UIView()
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
        title.adjustsFontSizeToFitWidth = true

        selectionStyle = .none
        isUserInteractionEnabled = true

        contentView.backgroundColor = .white
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .center
        stackView.spacing = 5

        view.addSubview(stackView)
        view.addSubview(accesoryView)
        contentView.addSubview(view)

        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(levelsContainer)

        view.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.contentView.readableArea)
            make.top.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        accesoryView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(27)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
        }

        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(accesoryView.snp.leading).offset(-10)
        }
    }
    
    // MARK: Public

    func customize(with model: Content) {
        title.text = model.title
        levelsContainer.subviews.forEach {
            $0.snp.removeConstraints()
            $0.removeFromSuperview()
        }
        model.levels.sorted(by: { (first, second) -> Bool in
            return first.key.rawValue < second.key.rawValue
        }).forEach { (organization, level) in
            let view = LevelView()
            view.customize(description: level, organization: organization)
            levelsContainer.addSubview(view)
        }
        for (index, view) in levelsContainer.subviews.enumerated() {
            guard let view = view as? LevelView else {
                return
            }
            if index == 0 {
                view.snp.makeConstraints { (make) in
                    make.leading.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
            } else {
                view.snp.makeConstraints { (make) in
                    make.leading.equalTo(self.levelsContainer.subviews[index - 1].snp.trailing).offset(20)
                    make.centerY.equalToSuperview()
                    if index == 1 {
                        make.centerX.equalToSuperview().offset(-30)
                    }
                }
            }
        }
        accesoryView.image = model.isDone ? UIImage(named: "done") : nil
    }

    func customizePrerequisite(with model: Content) {
        view.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        makeBorders(to: view)
        self.customize(with: model)
    }
    
    private func makeBorders(to view: UIView) {
        let bottomCorner = UIView()
        let leftCorner = UIView()
        let rightCorner = UIView()
        [bottomCorner, leftCorner, rightCorner].forEach {
            $0.backgroundColor = .lightGray
            view.addSubview($0)
        }
        bottomCorner.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        leftCorner.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(0.5)
        }
        
        rightCorner.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(0.5)
        }
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
        icon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        descriptionLabel.setContentHuggingPriority(.required, for: .horizontal)
        descriptionLabel.font = UIFont(name: "Helvetica", size: 12)
        descriptionLabel.textColor = .red
        descriptionLabel.adjustsFontSizeToFitWidth = true
        icon.contentMode = .scaleAspectFit
        icon.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(16)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    func customize(description: String?, organization: Organization) {
        descriptionLabel.text = description
        let image: String
        let size: CGFloat
        switch organization {
        case .ijru:
            image = "ijru"
            size = 16.0
        case .irsf:
            image = "irsf"
            size = 62.0
        case .wjr:
            image = "wjr"
            size = 62.0
        }
        icon.image = UIImage(named: image)
        icon.snp.makeConstraints { (make) in
            make.width.equalTo(size)
        }
    }

}

extension TrickLevelCell {
    struct Content: Hashable, Identifiable {
        var id = UUID()
        var title: String
        var levels: [Organization : String?]
        var isDone: Bool
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(levels)
            hasher.combine(isDone)
        }
    }
}

enum Organization: Int {
    case ijru = 0
    case irsf = 1
    case wjr = 2
}

