//
//  SidePanelDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SidePanelDataSource: NSObject, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "signin")
            cell.title.text = "Login"
            cell.itemDescription.text = "Sign in"
            return cell
        } else if indexPath.row == 1 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "tricktionary")
            cell.title.text = "Tricks"
            cell.itemDescription.text = "Home page"
            return cell
        }
        
        return UITableViewCell()
    }
}
