//
//  SpeedDataDetailViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SpeedDataDetailViewController: UIViewController {
    
    // MARK: Varaibles
    
    internal var tableView: UITableView = UITableView()
    internal var viewModel: SpeedDataDetailViewModel
    
    // MAKR: Life cycle
    
    init(viewModel: SpeedDataDetailViewModel) {
        self.viewModel = viewModel
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
        
        title = "Speed detail"
        view.backgroundColor = Color.background
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
        tableView.sectionHeaderHeight = 35
        tableView.backgroundColor = Color.background
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.dataSource = self
        tableView.delegate = self
        
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

