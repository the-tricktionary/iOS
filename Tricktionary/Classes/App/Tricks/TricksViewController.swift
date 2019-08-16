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
import KJExpandableTableTree
import MMDrawerController

class TricksViewController: BaseCenterViewController, UISearchControllerDelegate {
    
    // MARK: Variables
    
    var tableView: UITableView = UITableView()
    let sectionControll: UISegmentedControl = UISegmentedControl()
    internal var viewModel: TricksViewModel
    fileprivate var searchController: UISearchController!
    fileprivate let searchResultViewController: SearchResultViewController = SearchResultViewController()
    
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
        
        title = "Tricks"
        view.backgroundColor = Color.background
        
        sectionControll.insertSegment(withTitle: "Level 1", at: 0, animated: true)
        sectionControll.insertSegment(withTitle: "Level 2", at: 1, animated: true)
        sectionControll.insertSegment(withTitle: "Level 3", at: 2, animated: true)
        sectionControll.insertSegment(withTitle: "Level 4", at: 3, animated: true)
        sectionControll.insertSegment(withTitle: "Level 5", at: 4, animated: true)
        
        sectionControll.backgroundColor = Color.bar
        sectionControll.tintColor = UIColor(red: 254/255, green: 197/255, blue: 0/255, alpha: 1.0)
        sectionControll.sizeToFit()
        sectionControll.contentMode = .scaleAspectFill
        sectionControll.selectedSegmentIndex = 0
        
        sectionControll.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        navigationController?.navigationBar.isTranslucent = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.background
        tableView.contentInset = UIEdgeInsets(top: 45, left: 0, bottom: 16, right: 0)
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: TrickLevelCell.reuseIdentifier())
        tableView.register(TrickLevelHeaderCell.self, forCellReuseIdentifier: TrickLevelHeaderCell.reuseIdentifier())
        tableView.sectionHeaderHeight = 44
        tableView.tableFooterView = UIView()
        
        sectionControll.layer.zPosition = 800
        
        viewModel.onStartLoading = {
            self.activityIndicatorView.startAnimating()
        }
        
        viewModel.onFinishLoading = {
            self.activityIndicatorView.stopAnimating()
        }
        
        viewModel.tricks.producer.startWithValues { _ in
            self.tableView.reloadData()
        }
        
        self.viewModel.getTricks()
        
        setupSearchController()
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-1)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        sectionControll.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(45)
        }
    }
    
    fileprivate func setupSearchController() {
        searchResultViewController.viewModel = viewModel
        searchResultViewController.viewController = self
        searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = searchResultViewController
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        searchController.loadViewIfNeeded()
        
        searchController.searchBar.delegate = searchResultViewController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search trick"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .white
        
        for textField in searchController.searchBar.subviews.first!.subviews where textField is UITextField {
            textField.subviews.first?.backgroundColor = .white
            textField.subviews.first?.layer.cornerRadius = 10
        }
        navigationItem.searchController = searchController
    }
    
    // MARK: Public
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        viewModel.filteredTricks = viewModel.trickList.value.tricksForFiltering.filter({( trick : Trick) -> Bool in
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
}
