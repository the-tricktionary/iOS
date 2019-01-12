//
//  SidePanelDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SidePanelDelegate: NSObject, UITableViewDelegate {
    
    var viewController: SidePanelViewController!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            viewController.delegate?.didSelectMenuItem(viewController: LoginViewController())
        } else if indexPath.row == 1 {
            viewController.delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
        }
        
    }
}
