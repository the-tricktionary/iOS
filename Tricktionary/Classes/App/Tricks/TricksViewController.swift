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
    private let searchBar = UISearchController()
    private lazy var levelButton = self.makeLevelButton()
    private lazy var disciplinesButton = self.makeDisciplineButton()
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.getTricks()
        setupContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getTricks(silent: true)
    }
    // MARK: Privates

    private func setupContent() {
        title = "Tricks"

        view.backgroundColor = Color.background

        navigationItem.leftBarButtonItem = disciplinesButton
        navigationItem.rightBarButtonItem = levelButton

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.background
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: TrickLevelCell.reuseIdentifier())
        tableView.register(TrickLevelHeaderCell.self, forCellReuseIdentifier: TrickLevelHeaderCell.reuseIdentifier())
        tableView.register(TypeHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.sectionHeaderHeight = 44
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        setupViewConstraints()
    }

    private func bind() {
        viewModel.sections.producer.startWithValues { [weak self] _ in
            self?.levelButton.title = "Level \(self?.viewModel.selectedLevel ?? 1)"
            self?.tableView.reloadData()
        }

        viewModel.onStartLoading = { [weak self] in
            self?.activityIndicatorView.startAnimating()
        }

        viewModel.onFinishLoading = { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    fileprivate func setupViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    fileprivate func setupSearchController() {

    }

    private func makeLevelButton() -> UIBarButtonItem {
        let levelButton = UIBarButtonItem(title: "Level \(viewModel.selectedLevel)",
                                          style: .plain,
                                          target: self,
                                          action: #selector(changeLevelTapped))
        levelButton.tintColor = UIColor.flatYellow()
        return levelButton
    }

    private func makeDisciplineButton() -> UIBarButtonItem {
        let disciplinesButton = UIBarButtonItem(title: viewModel.disciplines[viewModel.selectedDiscipline].name,
                                                style: .plain,
                                                target: self,
                                                action: #selector(changeDisciplineTapped))
        disciplinesButton.tintColor = UIColor.flatYellow()
        return disciplinesButton
    }

    @objc private func changeLevelTapped() {
        viewModel.selectedLevel += 1
        levelButton.title = "Level \(viewModel.selectedLevel)"
    }

    @objc private func changeDisciplineTapped() {
        viewModel.selectedDiscipline += 1
        disciplinesButton.title = viewModel.disciplines[viewModel.selectedDiscipline].name
    }
}
