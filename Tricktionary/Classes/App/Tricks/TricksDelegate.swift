//
//  TricksDelegate.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TricksDelegate: NSObject, UITableViewDelegate {
    
    var viewModel: TricksViewModel!
    var viewController: TricksViewController!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if indexPath.section == 0 && indexPath.row > 0 {
                let trick = viewModel.level1.value[indexPath.row - 1]
                let trickDetailViewModel = TrickDetailViewModel(trick: trick)
                viewController.navigationController?.pushViewController(TrickDetailViewController(viewModel: trickDetailViewModel), animated: true)
            } else if indexPath.section == 1 && indexPath.row > 0 {
                let trick = viewModel.level2.value[indexPath.row - 1]
                let trickDetailViewModel = TrickDetailViewModel(trick: trick)
                viewController.navigationController?.pushViewController(TrickDetailViewController(viewModel: trickDetailViewModel), animated: true)
            } else if indexPath.section == 2 && indexPath.row > 0 {
                let trick = viewModel.level3.value[indexPath.row - 1]
                let trickDetailViewModel = TrickDetailViewModel(trick: trick)
                viewController.navigationController?.pushViewController(TrickDetailViewController(viewModel: trickDetailViewModel), animated: true)
            } else if indexPath.section == 3 && indexPath.row > 0 {
                let trick = viewModel.level4.value[indexPath.row - 1]
                let trickDetailViewModel = TrickDetailViewModel(trick: trick)
                viewController.navigationController?.pushViewController(TrickDetailViewController(viewModel: trickDetailViewModel), animated: true)
            } else if indexPath.section == 4 && indexPath.row > 0 {
                let trick = viewModel.level5.value[indexPath.row - 1]
                let trickDetailViewModel = TrickDetailViewModel(trick: trick)
                viewController.navigationController?.pushViewController(TrickDetailViewController(viewModel: trickDetailViewModel), animated: true)
            }
        
    }
}
