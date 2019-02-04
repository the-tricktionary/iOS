//
//  TrickDetailViewController.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickDetailViewController: UIViewController {
    
    // MARK: Variables
    
    let tableView: UITableView = UITableView()
    
    var viewModel: TrickDetailViewModel
    var dataSource: TrickDetailDataSource = TrickDetailDataSource()
    var delegate: TrickDetailDelegate = TrickDetailDelegate()
    
    // MARK: Life cycles
    
    init(viewModel: TrickDetailViewModel) {
        self.viewModel = viewModel
        self.viewModel.getTrick()
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
        
        title = viewModel.trickName
        
        view.backgroundColor = Color.background
        
        dataSource.viewModel = viewModel
        delegate.viewController = self
        delegate.viewModel = viewModel
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
        tableView.sectionHeaderHeight = 35
        tableView.backgroundColor = Color.background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        viewModel.loaded.producer.startWithValues { (value) in
            if value {
                self.tableView.reloadData()
            }
        }
        
        viewModel.loadedPrerequisites.producer.startWithValues { (value) in
            if value {
                self.tableView.reloadData()
            }
        }
        
        setupViewConstraints()
    }
    
    // MARK: Private
    
    fileprivate func setupViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}
