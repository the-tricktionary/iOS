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
import MMDrawerController
import ChameleonFramework

class TricksViewController: BaseCenterViewController, UISearchControllerDelegate {
    
    // MARK: Variables
    
    var tableView: UITableView = UITableView()
    let sectionControll: UISegmentedControl = UISegmentedControl()
    internal var viewModel: TricksViewModel
    fileprivate var searchController: UISearchController!
    fileprivate let searchResultViewController: SearchResultViewController = SearchResultViewController()
    private let disciplines = UISegmentedControl()
    
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
        tableView.addSubview(sectionControll)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()

        setupDisciplinePicker()
        disciplines.selectedSegmentIndex = viewModel.selectedDiscipline
        disciplines.addTarget(self, action: #selector(disciplineChanged), for: .valueChanged)
        navigationItem.titleView = disciplines
        navigationController?.view.backgroundColor = .white

        view.backgroundColor = Color.background
        
        setupLevelPicker()

        sectionControll.tintColor = UIColor.flatRed()
        sectionControll.sizeToFit()
        sectionControll.contentMode = .scaleAspectFill
        sectionControll.selectedSegmentIndex = 0
        sectionControll.backgroundColor = .white
        sectionControll.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.background
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 16, right: 0)
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: TrickLevelCell.reuseIdentifier())
        tableView.register(TrickLevelHeaderCell.self, forCellReuseIdentifier: TrickLevelHeaderCell.reuseIdentifier())
        tableView.sectionHeaderHeight = 44
        tableView.tableFooterView = UIView()
        
        sectionControll.layer.zPosition = 800
        sectionControll.alpha = 1.0
        
        self.viewModel.getTricks()
        
        setupSearchController()
        setupViewConstraints()
    }
    
    // MARK: Privates

    private func bind() {
        viewModel.onStartLoading = {
            self.activityIndicatorView.startAnimating()
        }

        viewModel.onFinishLoading = {
            self.setupLevelPicker()
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
        }

        viewModel.tricks.producer.startWithValues { _ in
            self.tableView.reloadData()
        }
    }

    private func setupLevelPicker() {
        viewModel.levels.enumerated().forEach { index, level in
            self.sectionControll.insertSegment(withTitle: "Level \(level)", at: index, animated: true)
        }
    }

    private func setupDisciplinePicker() {
        viewModel.disciplines.enumerated().forEach { (index, discipline) in
            disciplines.insertSegment(withTitle: discipline.name, at: index, animated: true)
        }
        sectionControll.selectedSegmentIndex = 0
    }
    
    fileprivate func setupViewConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-1)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        sectionControll.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(-3)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(-3)
            make.height.equalTo(45)
        }
    }
    
    fileprivate func setupSearchController() {
//        searchResultViewController.viewModel = viewModel
//        searchResultViewController.viewController = self
//        searchController = UISearchController(searchResultsController: searchResultViewController)
//        searchController.delegate = self
//        searchController.searchResultsUpdater = searchResultViewController
//        searchController.dimsBackgroundDuringPresentation = true
//        searchController.view.backgroundColor = .white
//        definesPresentationContext = false
//
//        searchController.loadViewIfNeeded()
//
//        searchController.searchBar.delegate = searchResultViewController
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.placeholder = "Search trick"
//        searchController.searchBar.sizeToFit()
//
//        navigationItem.searchController = searchController
    }
    
    // MARK: Public
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        viewModel.filteredTricks = viewModel.tricks.value.filter({( trick : Trick) -> Bool in
            return trick.name.lowercased().contains(searchText.lowercased())
        })
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    
    // MARK: User action
    
    @objc func searchTapped() {
        navigationItem.titleView = searchController.view
    }
    
    @objc func segmentChanged() {
        viewModel.selectedLevel = sectionControll.selectedSegmentIndex + 1
        tableView.reloadData()
    }

    @objc func disciplineChanged(sender: UISegmentedControl) {
        sectionControll.removeAllSegments()
        viewModel.selectedDiscipline = sender.selectedSegmentIndex
    }
}
