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

class TricksViewController: UIViewController {
    
    // MARK: Variables
    
    fileprivate let tableView: UITableView = UITableView()
    fileprivate var viewModel: TricksViewModel
    fileprivate let delegate: TricksDelegate = TricksDelegate()
    fileprivate let dataSource: TricksDataSource = TricksDataSource()
    
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
        view.backgroundColor = UIColor.lightGray
        
        tableView.backgroundColor = UIColor.lightGray
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        dataSource.viewModel = viewModel
        delegate.viewModel = viewModel
        delegate.viewController = self
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: "TrickLevel")
        
        viewModel.level1.producer.startWithValues { (value) in
            if value.count > 0 {
                self.tableView.reloadData()
            }
        }
        viewModel.level2.producer.startWithValues { (value) in
            if value.count > 0 {
                self.tableView.reloadData()
            }
        }
        viewModel.level3.producer.startWithValues { (value) in
            if value.count > 0 {
                self.tableView.reloadData()
            }
        }
        viewModel.level4.producer.startWithValues { (value) in
            if value.count > 0 {
                self.tableView.reloadData()
            }
        }
        viewModel.level5.producer.startWithValues { (value) in
            if value.count > 0 {
                self.tableView.reloadData()
            }
        }
        
        setupViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
