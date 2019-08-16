//
//  SpeedDataViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 21/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class SpeedDataViewController: BaseCenterViewController {
    
    // MARK: Variables
    
    internal var viewModel: SpeedDataViewModel
    internal var tableView: UITableView =  UITableView()
    private lazy var loginPlaceholder: UIView = {
        let placeholder = UIView()
        placeholder.backgroundColor = .gray
        placeholder.layer.zPosition = 999
        self.view.addSubview(placeholder)
        placeholder.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        return placeholder
    }()
    
    // MARK: Life cycle
    
    init(viewModel: SpeedDataViewModel) {
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
        view.backgroundColor = Color.background
        title = "Speed data"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        
        setupViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            loginPlaceholder.isHidden = false
        } else {
            loginPlaceholder.isHidden = true
            if viewModel.speeds.count == 0 {
                viewModel.getSpeedData(starting: {
                    self.activityIndicatorView.startAnimating()
                }) {
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
