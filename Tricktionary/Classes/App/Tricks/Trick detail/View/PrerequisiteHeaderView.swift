//
//  PrerequisiteHeaderView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 28/03/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class PrerequisiteHeaderView: UIView {

    // MARK: - Variables
    private let title = UILabel()
    private let accessoryImageView = UIImageView()

    private let view = UIView()
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content
    private func setupContent() {
        addSubview(view)
        
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor

        view.addSubview(title)
        view.addSubview(accessoryImageView)

        accessoryImageView.tintColor = UIColor.lightGray

        view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.leading.equalTo(view).inset(16)
            make.trailing.equalTo(view).inset(41)
        }

        accessoryImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(25)
            make.centerY.equalToSuperview()
        }
    }

    func customize(title: String?, collapsed: Bool) {
        self.title.text = title
        accessoryImageView.image = collapsed ? UIImage(named: "collapsed") : UIImage(named: "expanded")
    }
}
