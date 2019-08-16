//
//  SidePanelDataSource.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        if let _ = Auth.auth().currentUser {
            return 6
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let user = Auth.auth().currentUser {
                let cell = UserCell()
                if let photo = user.photoURL {
                    do {
                        let data = try Data(contentsOf: photo)
                        cell.icon.image = UIImage(data: data)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    cell.icon.image = UIImage(named: "signin")
                }
                cell.title.text = user.displayName ?? user.email
                return cell
            } else {
                let cell = UserCell()
                cell.icon.image = UIImage(named: "signin")
                cell.title.text = "Sign In"
                return cell
            }
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let headerCell = UITableViewCell()
                headerCell.backgroundColor = UIColor.red
                headerCell.selectionStyle = .none
                return headerCell
            }
            
            if let _ = Auth.auth().currentUser {
                if indexPath.row == 1 {
                    let cell = MenuCell()
                    cell.icon.image = UIImage(named: "instagram")
                    cell.title.text = "Instagram"
                    cell.itemDescription.text = "@jumpropetricktionary"
                    return cell
                } else if indexPath.row == 2 {
                    let cell = MenuCell()
                    cell.icon.image = UIImage(named: "web")
                    cell.title.text = "Web"
                    cell.itemDescription.text = "the-tricktionary.com"
                    return cell
                } else if indexPath.row == 3 {
                    let cell = MenuCell()
                    cell.icon.image = UIImage(named: "contact")
                    cell.title.text = "Contact"
                    cell.itemDescription.text = "View your past feedback"
                    return cell
                } else if indexPath.row == 4 {
                    let cell = MenuCell()
                    cell.icon.image = UIImage(named: "writer")
                    cell.title.text = "Show Writer"
                    cell.itemDescription.text = "Spread routines evenly"
                    return cell
                } else if indexPath.row == 5 {
                    let cell = MenuCell() // TODO: Sign out cell
                    cell.removeDescription()
                    cell.icon.image = UIImage(named: "signin")
                    cell.title.text = "Sign out"
                    return cell
                }
            } else {
                if indexPath.row == 1 {
                    let cell = MenuCell()
                    cell.icon.image = UIImage(named: "instagram")
                    cell.title.text = "Instagram"
                    cell.itemDescription.text = "@jumpropetricktionary"
                    return cell
                } else if indexPath.row == 2 {
                    let cell = MenuCell()
                    cell.icon.image = UIImage(named: "web")
                    cell.title.text = "Web"
                    cell.itemDescription.text = "the-tricktionary.com"
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
}
