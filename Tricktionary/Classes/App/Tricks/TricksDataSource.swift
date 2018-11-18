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
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.level1.value.count + 1
        } else if section == 1 {
            return viewModel.level2.value.count + 1
        } else if section == 2 {
            return viewModel.level3.value.count + 1
        } else if section == 3 {
            return viewModel.level4.value.count + 1
        } else if section == 4 {
            return viewModel.level5.value.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = TrickLevelHeaderCell()
                cell.title.text = Level.level1.description()
                return cell
            }
            let cell = TrickLevelCell()
            let trick = viewModel.level1.value[indexPath.row - 1]
            cell.title.text = trick.name
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = TrickLevelHeaderCell()
                cell.title.text = Level.level2.description()
                return cell
            }
            let cell = TrickLevelCell()
            let trick = viewModel.level2.value[indexPath.row - 1]
            cell.title.text = trick.name
            return cell
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = TrickLevelHeaderCell()
                cell.title.text = Level.level3.description()
                return cell
            }
            let cell = TrickLevelCell()
            let trick = viewModel.level3.value[indexPath.row - 1]
            cell.title.text = trick.name
            return cell
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = TrickLevelHeaderCell()
                cell.title.text = Level.level4.description()
                return cell
            }
            let cell = TrickLevelCell()
            let trick = viewModel.level4.value[indexPath.row - 1]
            cell.title.text = trick.name
            return cell
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let cell = TrickLevelHeaderCell()
                cell.title.text = Level.level5.description()
                return cell
            }
            let cell = TrickLevelCell()
            let trick = viewModel.level5.value[indexPath.row - 1]
            cell.title.text = trick.name
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
