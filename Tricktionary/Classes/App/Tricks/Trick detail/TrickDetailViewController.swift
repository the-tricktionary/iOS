//
//  TrickDetailViewController.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class TrickDetailViewController: BaseCenterViewController {
    
    // MARK: Variables
    
    let tableView: UITableView = UITableView()
    private let videoView = VideoView()
    
    var viewModel: TrickDetailViewModelType
    
    // MARK: Life cycles
    
    init(viewModel: TrickDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(videoView)
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()

        self.viewModel.getTrick(by: "") // TODO: 
        
        title = "trick name"//viewModel.trickName TODO: 
        
        view.backgroundColor = .white

        tableView.sectionHeaderHeight = 35
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(TrickInfoCell.self, forCellReuseIdentifier: "TrickInfo")
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: "TrickDescription")
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: "TrickPrerequisites")
        
        setupViewConstraints()
    }
    
    // MARK: Private

    private func bind() {
        viewModel.onLoad = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.video.sink { [weak self] content in
            guard let sSelf = self, let content = content else {
                return
            }
            sSelf.videoView.customize(with: content)
        }.store(in: &disposable)

        viewModel.preprequisites.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &disposable)
    }
    
    fileprivate func setupViewConstraints() {
        videoView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.readableArea)
            make.height.equalTo(211)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(videoView.snp.bottom)
            make.leading.trailing.equalTo(self.view.readableArea)
            make.bottom.equalTo(view)
        }
    }
}
