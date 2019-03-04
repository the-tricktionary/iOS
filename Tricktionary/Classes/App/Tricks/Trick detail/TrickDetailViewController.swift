//
//  TrickDetailViewController.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickDetailViewController: BaseViewController {
    
    // MARK: Variables
    
    let tableView: UITableView = UITableView()
    
    var viewModel: TrickDetailViewModel
    
    // MARK: Life cycles
    
    init(viewModel: TrickDetailViewModel) {
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
        
        title = viewModel.trickName
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.getTrick(starting: {
            self.activityIndicatorView.startAnimating()
        }) {
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
        }
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
