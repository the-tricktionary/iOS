//
//  SidePanelViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 10/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

public protocol SidePanelViewControllerDelegate {
    func didSelectMenuItem(viewController: UIViewController)
}

class SidePanelViewController: UIViewController {
    
    // MARK: Variables
    
    var tableView: UITableView = UITableView()
    var dataSource: SidePanelDataSource = SidePanelDataSource()
    var tableDelegate: SidePanelDelegate = SidePanelDelegate()
    
    var delegate: SidePanelViewControllerDelegate?
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            print("MAM PRIHLASENEHO \(user.displayName)")
        } else {
            print("MAM LEDA HOVNO")
        }
        view.backgroundColor = UIColor.red
        
        tableDelegate.viewController = self
        
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.red
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.dataSource = dataSource
        tableView.delegate = tableDelegate
        
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
