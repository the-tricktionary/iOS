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

class TricksViewController: MenuItemViewController, UISearchControllerDelegate {
    
    // MARK: Variables
    
    let tableView: UITableView = UITableView()
    fileprivate var viewModel: TricksViewModel
    fileprivate let tableDelegate: TricksDelegate = TricksDelegate()
    fileprivate let dataSource: TricksDataSource = TricksDataSource()
    fileprivate var searchController: UISearchController!
    fileprivate let searchResultViewController: SearchResultViewController = SearchResultViewController()
    
    var kjtreeInstance: KJTree = KJTree()
    
    // MARK: Life cycles
    
    init(viewModel: TricksViewModel) {
        self.viewModel = viewModel
        self.viewModel.getTricks()
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
        navigationItem.title = "Tricks"
        view.backgroundColor = Color.background
        
        let randomButton = UIBarButtonItem(image: UIImage(named: "random"),
                                           landscapeImagePhone: nil,
                                           style: .done,
                                           target: self,
                                           action: #selector(randomTapped))
        
        navigationItem.rightBarButtonItem = randomButton
        
        tableView.backgroundColor = Color.background
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        dataSource.viewModel = viewModel
        tableDelegate.viewModel = viewModel
        dataSource.viewController = self
        tableDelegate.viewController = self
        tableView.delegate = tableDelegate
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.register(TrickLevelCell.self, forCellReuseIdentifier: "TrickLevel")
        
        viewModel.isLoaded.producer.startWithValues { (value) in
            if value {
                if let arrayOfParents = self.viewModel.getArrayOfParrents() {
                    self.kjtreeInstance = KJTree(parents: arrayOfParents, childrenKey: "child", expandableKey: "Expanded", key: "Id")
                }
                self.kjtreeInstance.isInitiallyExpanded = false
                self.tableView.reloadData()
            }
        }
        
        setupSearchController()
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
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
        searchController.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        searchController.searchBar.tintColor = self.view.tintColor
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
    
    @objc func randomTapped() {
        let randomTrick = viewModel.trickList.value.tricksForFiltering.randomElement()
        if let trick = randomTrick {
            let trickDetailViewModel = TrickDetailViewModel(trick: trick.name)
            navigationController?.pushViewController(TrickDetailViewController(viewModel: trickDetailViewModel), animated: true)
        }
    }
}
