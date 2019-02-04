//
//  SettingsViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 24/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: MenuItemViewController {
    
    // MARK: Variables
    
    var tableView: UITableView = UITableView()
    let tableDelegate: SettingsDelegate = SettingsDelegate()
    let dataSource: SettingsDataSource = SettingsDataSource()
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.background
        
        navigationItem.title = "Settings"
        
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
        tableView.tableHeaderView = UIView()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    
        tableView.sectionHeaderHeight = 35
        tableView.sectionFooterHeight = 35
        
        tableView.delegate = tableDelegate
        tableView.dataSource = dataSource
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}
