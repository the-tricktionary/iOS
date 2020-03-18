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

class TricksViewController: BaseCenterViewController, UISearchResultsUpdating {

    // MARK: - Variables
    private lazy var searchController = self.makeSearchController()
    private let refreshControl = UIRefreshControl()
    private let searchResults = TrickSearchVC()
    private lazy var levelButton = self.makeLevelButton()
    private lazy var disciplinesButton = self.makeDisciplineButton()
    var tableView: UITableView = UITableView()
    internal var viewModel: TricksViewModel
    
    // MARK: - Life cycles
    
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
    // MARK: - Privates

    private func setupContent() {
        title = "Tricks"

        view.backgroundColor = Color.background

        navigationItem.leftBarButtonItem = disciplinesButton
        navigationItem.rightBarButtonItem = levelButton
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController

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
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

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
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
        searchResults.onSelectTrick = { [weak self] trick in
            let vm = TrickDetailViewModel(trick: trick, settings: Settings(), done: false)
            let vc = TrickDetailViewController(viewModel: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func setupViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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

    private func makeSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: searchResults)
        searchController.searchBar.tintColor = .white
        if #available(iOS 13, *) {
            searchController.searchBar.searchTextField.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        } else {
            for textField in searchController.searchBar.subviews.first!.subviews where textField is UITextField {
                textField.subviews.first?.backgroundColor = UIColor.flatRed()?.withAlphaComponent(0.1)
                textField.subviews.first?.layer.cornerRadius = 10
            }
        }
        searchController.searchResultsUpdater = self

        let textField = searchController.searchBar.value(forKey: "searchField") as! UITextField
        let glassIconView = textField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = UIColor.white

        let clearButton = textField.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.white

        return searchController
    }

    @objc private func changeLevelTapped() {
        let levelPicker = UIAlertController(title: nil, message: "Select level", preferredStyle: .actionSheet)
        viewModel.levels.forEach { level in
            let action = UIAlertAction(title: "Level \(level)", style: .default) { _ in
                self.viewModel.selectedLevel = level
                self.levelButton.title = "Level \(self.viewModel.selectedLevel)"
            }
            levelPicker.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        levelPicker.addAction(cancel)
        present(levelPicker, animated: true, completion: nil)
    }

    @objc private func changeDisciplineTapped() {
        let disciplinePicker = UIAlertController(title: nil, message: "Select discipline", preferredStyle: .actionSheet)
        for (index, discipline) in viewModel.disciplines.enumerated() {
            let action = UIAlertAction(title: discipline.name, style: .default) { _ in
                self.viewModel.selectedDiscipline = index
                self.disciplinesButton.title = self.viewModel.disciplines[self.viewModel.selectedDiscipline].name
            }
            disciplinePicker.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        disciplinePicker.addAction(cancel)
        present(disciplinePicker, animated: true, completion: nil)
    }

    @objc private func refresh() {
        viewModel.isPullToRefresh = true
        viewModel.getTricks()
    }

    // MARK: - Searching
    func updateSearchResults(for searchController: UISearchController) {
        searchResults.filteredTricks.value = viewModel.getFilteredTricks(substring: searchController.searchBar.text ?? "") ?? []
    }
}
