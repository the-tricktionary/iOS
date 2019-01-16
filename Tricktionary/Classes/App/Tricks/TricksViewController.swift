//
//  TricksViewController.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FirebaseFirestore
import ReactiveSwift
import KJExpandableTableTree

class TricksViewController: MenuItemViewController {
    
    // MARK: Variables
    
    let tableView: UITableView = UITableView()
    fileprivate var viewModel: TricksViewModel
    fileprivate let tableDelegate: TricksDelegate = TricksDelegate()
    fileprivate let dataSource: TricksDataSource = TricksDataSource()
    
    var kjtreeInstance: KJTree = KJTree()
    
    // MARK: Life cycles
    
    init(viewModel: TricksViewModel) {
        self.viewModel = viewModel
        self.viewModel.getTricks()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tricks"
        view.backgroundColor = UIColor.white
        
        tableView.backgroundColor = UIColor.white
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        dataSource.viewModel = viewModel
        tableDelegate.viewModel = viewModel
        dataSource.viewController = self
        tableDelegate.viewController = self
        tableView.delegate = tableDelegate
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: "TrickLevel")
        
        viewModel.isLoaded.producer.startWithValues { (value) in
            if value {
                if let arrayOfParents = self.viewModel.getArrayOfParrents() {
                    self.kjtreeInstance = KJTree(parents: arrayOfParents, childrenKey: "child", expandableKey: "Expanded", key: "Id")
                }
                self.kjtreeInstance.isInitiallyExpanded = false
                self.tableView.reloadData()
            }
        }
        
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
