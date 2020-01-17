//
//  SettingsViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 24/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: BaseCenterViewController {
    
    // MARK: Variables
    @Persistent(key: PxSettings.autoplay, defaultValue: false)
    var auto: Bool

    @Persistent(key: PxSettings.fullscreen, defaultValue: false)
    var fullscreen: Bool

    @Persistent(key: PxSettings.ijruLevels, defaultValue: false)
    var showIjru: Bool

    @Persistent(key: PxSettings.irsfLevels, defaultValue: false)
    var showIrsf: Bool

    @Persistent(key: PxSettings.wjrLevels, defaultValue: false)
    var showWjr: Bool

    var tableView: UITableView = UITableView()
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Settings"
        
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
        tableView.tableHeaderView = UIView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}
