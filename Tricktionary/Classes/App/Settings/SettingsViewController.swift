//
//  SettingsViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 24/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: BaseCenterViewController {
    
    // MARK: Variables
    var tableView: UITableView = UITableView()
    internal var vm: SettingsViewModelType
    
    // MARK: Life cycles

    init(viewModel: SettingsViewModelType) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        if #available(iOS 13.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        } else {
            let closeButton = UIBarButtonItem(image: UIImage(named: "clear"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(close))
            closeButton.tintColor = .white
            navigationItem.leftBarButtonItem = closeButton
        }

        navigationItem.title = "Settings"
        
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
        tableView.tableHeaderView = UIView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }

    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
