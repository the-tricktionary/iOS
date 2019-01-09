//
//  MenuDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class MenuDataSource: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = InformationCell()
            cell.title.text = "Login"
            cell.info.text = "Login"
            return cell
        } else if indexPath.row == 1 {
            let cell = InformationCell()
            cell.title.text = "Tricks"
            cell.info.text = "Tricks"
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
}
