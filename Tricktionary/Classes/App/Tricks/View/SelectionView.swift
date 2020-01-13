//
//  SelectionView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 13/01/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SelectionView: UIView {

    // MARK: - Variables
    private let leftSection = UILabel()
    private let rightSection = UILabel()

    var onRightTapped: (() -> Void)?

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content

    private func setupContent() {
        leftSection.textColor = .black
        leftSection.textAlignment = .left

        rightSection.textColor = .black
        rightSection.textAlignment = .right

        let gestureRight = UITapGestureRecognizer(target: self, action: #selector(rightTapped))
        rightSection.isUserInteractionEnabled = true
        rightSection.addGestureRecognizer(gestureRight)

        addSubview(leftSection)
        addSubview(rightSection)

        setupConstraints()
    }

    private func setupConstraints() {
        leftSection.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(self.snp.centerX)
            make.centerY.equalToSuperview()
        }

        rightSection.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.centerX)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }

    func customize(with model: Content) {
        leftSection.text = model.left
        rightSection.text = model.right
    }

    @objc private func rightTapped() {
        self.onRightTapped?()
    }
}

extension SelectionView {
    struct Content {
        var left: String
        var right: String
    }
}
