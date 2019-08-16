//
//  TrickCoordinator.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 16/07/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickCoordinator {
    
    var presenter: UINavigationController?
    var trick: String
    
    init(presenter: UINavigationController?, trickName: String) {
        self.presenter = presenter
        self.trick = trickName
    }
    
    func start() {
        let vm = TrickDetailViewModel(trick: trick)
        let vc = TrickDetailViewController(viewModel: vm)
        
        vm.onStartLoading = { [weak vc] in
            vc?.activityIndicatorView.startAnimating()
        }
        
        vm.onLoad = { [weak vc] in
            vc?.activityIndicatorView.stopAnimating()
            vc?.tableView.reloadData()
        }
        
        presenter?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
