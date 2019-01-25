//
//  SettingsDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 25/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SettingsDataSource: NSObject, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Video settings"
                cell.backgroundColor = Color.backgroundHeader
                return cell
            case 1:
                let cell = SwitchCell()
                cell.title.text = "Automatic full screen"
                return cell
            case 2:
                let cell = SwitchCell()
                cell.title.text = "Auto-Play Videos"
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
}
