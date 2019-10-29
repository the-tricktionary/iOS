//
//  TrickDetailDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension TrickDetailViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 250
        }
        if indexPath.section == 2 || indexPath.section == 3 {
            return 67
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trick = viewModel.trick {
            if trick.prerequisites?.count ?? 0 > 0 {
                if indexPath.section == 3 {
                    let cell = tableView.cellForRow(at: indexPath) as! InformationCell
//                    let newScreen = UserDefaults.standard.value(forKey: PxSettings.newScreen) as? Bool ?? false
//                    if newScreen {
//                        let nextDetailViewController = TrickDetailViewController(viewModel: TrickDetailViewModel(trick: cell.title.text!))
//                        navigationController?.pushViewController(nextDetailViewController, animated: true)
//                    } else {
                        viewModel.trickName = cell.title.text!
                        viewModel.getTrick()
                        title = cell.title.text!
//                    }
                }
            }
        }
    }
}
