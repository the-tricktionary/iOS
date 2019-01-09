//
//  MenuDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class MenuDelegate: NSObject, UITableViewDelegate {
    
    var viewController: MenuViewController!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            viewController.sideMenuController?.setContentViewController(contentViewController: LoginViewController(), animation: true)
            viewController.sideMenuController?.hideMenu()
        } else if indexPath.row == 1 {
            let trickViewModel = TricksViewModel()
            let trickViewController = TricksViewController(viewModel: trickViewModel)
            viewController.sideMenuController?.setContentViewController(contentViewController: trickViewController, animation: true)
            viewController.sideMenuController?.hideMenu()
        }
    }
}
