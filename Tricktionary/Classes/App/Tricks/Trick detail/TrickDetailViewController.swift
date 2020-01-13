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

        viewModel.onLoad = { [weak self] in
            self?.tableView.reloadData()
        }

        self.viewModel.getTrick()
        
        title = viewModel.trickName
        
        view.backgroundColor = Color.background

        tableView.sectionHeaderHeight = 35
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identity)
        
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
