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
        return 10
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
            cell.title.text = "Tricktionary"
            cell.itemDescription.text = "Home page"
            return cell
        } else if indexPath.row == 2 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "timer")
            cell.title.text = "Speed Timer"
            cell.itemDescription.text = "Click speed events"
            return cell
        } else if indexPath.row == 3 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "data")
            cell.title.text = "Speed Data"
            cell.itemDescription.text = "Store your speed scores"
            return cell
        } else if indexPath.row == 4 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "submit")
            cell.title.text = "Submit"
            cell.itemDescription.text = "Send in your jump rope tricks"
            return cell
        } else if indexPath.row == 5 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "instagram")
            cell.title.text = "Instagram"
            cell.itemDescription.text = "@jumpropetricktionary"
            return cell
        } else if indexPath.row == 6 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "web")
            cell.title.text = "Web"
            cell.itemDescription.text = "the-tricktionary.com"
            return cell
        } else if indexPath.row == 7 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "contact")
            cell.title.text = "Contact"
            cell.itemDescription.text = "View your past feedback"
            return cell
        } else if indexPath.row == 8 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "writer")
            cell.title.text = "Show Writer"
            cell.itemDescription.text = "Spread routines evenly"
            return cell
        } else if indexPath.row == 9 {
            let cell = MenuCell()
            cell.icon.image = UIImage(named: "settings")
            cell.title.text = "Settings"
            cell.itemDescription.text = "Language, video and profile settings"
            return cell
        }
        
        
        return UITableViewCell()
    }
}
