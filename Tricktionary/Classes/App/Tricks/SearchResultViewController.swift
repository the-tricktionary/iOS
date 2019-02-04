//
//  SearchResultViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 04/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SearchResultViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Variables
    
    var viewModel: TricksViewModel!
    var viewController: TricksViewController!
    
    // MARK: Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewController.isFiltering() {
            return viewModel.filteredTricks.count
        }
        
        return viewModel.trickList.value.tricksForFiltering.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let selected: Trick
        if viewController.isFiltering() {
            selected = viewModel.filteredTricks[indexPath.row]
        } else {
            selected = viewModel.trickList.value.tricksForFiltering[indexPath.row]
        }
        cell.textLabel?.text = selected.name
        cell.detailTextLabel?.text = "Level \(selected.level) \(selected.type)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem: Trick
        if viewController.isFiltering() {
            selectedItem = viewModel.filteredTricks[indexPath.row]
        } else {
            selectedItem = viewModel.trickList.value.tricksForFiltering[indexPath.row]
        }
        dismiss(animated: true, completion: {
            let trickDetailViewModel = TrickDetailViewModel(trick: selectedItem.name)
            let trickDetalViewController = TrickDetailViewController(viewModel: trickDetailViewModel)
            self.viewController.navigationController?.pushViewController(trickDetalViewController, animated: true)
        })
    }
    
    // MARK
    
    func updateSearchResults(for searchController: UISearchController) {
        viewController.filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
}
