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
    let count = UILabel()
    let accesoryView = UIImageView()
    var onTapped: ((String) -> Void)?
    private var sectionName: String?
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

    func customize(with titleLabel: String?, completed: Int?, from: Int, collapsed: Bool) {
        self.sectionName = titleLabel
        title.text = "\(titleLabel?.first?.uppercased() ?? "")" + "\(titleLabel?.dropFirst() ?? "")"
        accesoryView.image = collapsed ? UIImage(named: "collapsed") : UIImage(named: "expansed")
        if let completed = completed {
            count.text = "\(completed)/\(from)"
        } else {
            count.text = "\(from)"
        }
    }
    
    // MARK: Privates
    
    private func setupSubViews() {
        addSubview(title)
        addSubview(count)
        addSubview(accesoryView)
    }
    
    private func setupViewsStyle() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.flatYellow()
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textColor = .white
        title.textAlignment = .justified

        count.font = UIFont.systemFont(ofSize: 14)
        count.textColor = .white
        count.textAlignment = .right

        accesoryView.tintColor = .white
        accesoryView.image = UIImage(named: "expansed")

        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
    }
    
    private func setupViewConstraints() {
        title.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(10)
            make.centerY.equalTo(self)
        }

        accesoryView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }

        count.snp.makeConstraints { (make) in
            make.leading.equalTo(title)
            make.trailing.equalTo(accesoryView.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
        }
        
        backgroundView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }

    @objc private func tapped() {
        onTapped?(sectionName ?? "")
    }

    class func reuseIdentifier() -> String {
        return "typeHeaderCell"
    }
}
