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
        
        let node = viewController.kjtreeInstance.tableView(tableView, didSelectRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        
        if indexTuples.count == 3 {
            let trickDetailViewModel = TrickDetailViewModel(trick: node.key)
            let trickDetalViewController = TrickDetailViewController(viewModel: trickDetailViewModel)
            viewController.navigationController?.pushViewController(trickDetalViewController, animated: true)
        }
    }
}
