//
//  TricksDataSource.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class TricksDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: TricksViewModel!
    var viewController: TricksViewController!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let total = viewController.kjtreeInstance.tableView(tableView, numberOfRowsInSection: section)
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let node = viewController.kjtreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        
        
        if indexTuples.count == 1  || indexTuples.count == 4 {
            
            // Parents
            
            let cell = TrickLevelHeaderCell()
            cell.title.text = "Level \(node.key)"
            return cell
            
        } else if indexTuples.count == 2 {
            let cell = TrickLevelCell()
            cell.title.textColor = UIColor.red
            cell.title.text = node.key.uppercased()
            return cell
        } else if indexTuples.count == 3 {
            let cell = TrickLevelCell()
            cell.title.text = node.key
            return cell
        }
        return UITableViewCell()
    }
    
    
}
