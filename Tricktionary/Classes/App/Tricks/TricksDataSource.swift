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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.level1.value.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = TrickLevelHeaderCell()
                cell.title.text = "Level 1"
                return cell
            }
            let cell = TrickLevelCell()
            let trick = viewModel.level1.value[indexPath.row - 1]
            cell.title.text = trick.name!
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
