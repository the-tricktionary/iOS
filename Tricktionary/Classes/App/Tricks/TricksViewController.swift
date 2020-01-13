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
import ChameleonFramework

class TricksViewController: BaseCenterViewController {
    
    // MARK: Variables
    private let selectionView = SelectionView()
    var tableView: UITableView = UITableView()
    internal var viewModel: TricksViewModel
    
    // MARK: Life cycles
    
    init(viewModel: TricksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        view.addSubview(selectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.getTricks()
        setupContent()
    }
    
    // MARK: Privates

    private func setupContent() {
        title = "Tricks"

        view.backgroundColor = Color.background

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.background
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: TrickLevelCell.reuseIdentifier())
        tableView.register(TrickLevelHeaderCell.self, forCellReuseIdentifier: TrickLevelHeaderCell.reuseIdentifier())
        tableView.register(TypeHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.sectionHeaderHeight = 44
        tableView.tableFooterView = UIView()

        selectionView.backgroundColor = .white
        selectionView.customize(with: SelectionView.Content(left: viewModel.disciplines[viewModel.selectedDiscipline].name,
                                                            right: "Level \(viewModel.selectedLevel)"))

        setupViewConstraints()
    }

    private func bind() {
        viewModel.sections.producer.startWithValues { [weak self] _ in
            self?.tableView.reloadData()
        }

        viewModel.onStartLoading = { [weak self] in
            self?.activityIndicatorView.startAnimating()
        }

        viewModel.onFinishLoading = { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.tableView.reloadData()
        }
        selectionView.onRightTapped = { [weak self] in
            self?.viewModel.selectedLevel += 1
            self?.selectionView.customize(with: SelectionView.Content(left: self?.viewModel.disciplines[self?.viewModel.selectedDiscipline ?? 0].name ?? "",
                                                                      right: "Level \(self?.viewModel.selectedLevel ?? 1)"))
        }
    }
    
    fileprivate func setupViewConstraints() {
        selectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(45)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(selectionView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    fileprivate func setupSearchController() {

    }
}
