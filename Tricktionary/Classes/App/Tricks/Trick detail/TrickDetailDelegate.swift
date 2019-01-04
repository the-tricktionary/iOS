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
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trick = viewModel.trick {
            if trick.prerequisites.count > 0 {
                if indexPath.row > 4 {
                    let cell = tableView.cellForRow(at: indexPath) as! InformationCell
                    viewModel.trickName = cell.title.text!
                    viewModel.getTrick()
                    viewController.title = cell.title.text!
                }
            }
        }
    }
}
