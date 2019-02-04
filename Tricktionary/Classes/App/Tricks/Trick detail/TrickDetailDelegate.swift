//
//  TrickDetailDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TrickDetailDelegate: NSObject, UITableViewDelegate {
    
    var viewController: TrickDetailViewController!
    var viewModel: TrickDetailViewModel!
 
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 || indexPath.section == 3 {
            return 67
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trick = viewModel.trick {
            if trick.prerequisites.count > 0 {
                if indexPath.section == 3 {
                    let cell = tableView.cellForRow(at: indexPath) as! InformationCell
                    let newScreen = UserDefaults.standard.value(forKey: PxSettings.newScreen) as? Bool ?? false
                    if newScreen {
                        let nextDetailViewController = TrickDetailViewController(viewModel: TrickDetailViewModel(trick: cell.title.text!))
                        viewController.navigationController?.pushViewController(nextDetailViewController, animated: true)
                    } else {
                        viewModel.trickName = cell.title.text!
                        viewModel.getTrick()
                        viewController.title = cell.title.text!
                    }
                }
            }
        }
    }
}
