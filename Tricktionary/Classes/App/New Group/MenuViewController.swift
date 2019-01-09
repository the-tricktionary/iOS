//
//  MenuViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class MenuViewController: UIViewController {
    
    // MARK: Variables
    
    let tableView: UITableView = UITableView()
    fileprivate let delegate: MenuDelegate = MenuDelegate()
    fileprivate let dataSource: MenuDataSource = MenuDataSource()
    
    // MARK: Life cycle
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate.viewController = self
        
        tableView.backgroundColor = UIColor.red
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 45
        tableView.separatorStyle = .none
        
        tableView.delegate = delegate
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
