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
import FirebaseAuth
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
            if let _ = Auth.auth().currentUser {
                if indexPath.row == 0 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "instagram")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Instagram"
                    cell.detailTextLabel?.text = "@jumpropetricktionary"
                    return cell
                } else if indexPath.row == 1 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "web")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Web"
                    cell.detailTextLabel?.text = "the-tricktionary.com"
                    return cell
                } else if indexPath.row == 2 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "contact")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Contact"
                    cell.detailTextLabel?.text = "View your past feedback"
                    return cell
                } else if indexPath.row == 3 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "writer")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Show Writer"
                    cell.detailTextLabel?.text = "Spread routines evenly"
                    return cell
                } else if indexPath.row == 4 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "settings")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Settings"
                    cell.detailTextLabel?.text = "Settings"
                    return cell
                } else if indexPath.row == 5 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "signin")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Sign out"
                    return cell
                }
            } else {
                if indexPath.row == 0 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "instagram")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Instagram"
                    cell.detailTextLabel?.text = "@jumpropetricktionary"
                    return cell
                } else if indexPath.row == 1 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "web")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Web"
                    cell.detailTextLabel?.text = "the-tricktionary.com"
                    return cell
                } else if indexPath.row == 2 {
                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                    cell.selectionStyle = .none
                    cell.imageView?.image = UIImage(named: "settings")
                    cell.imageView?.tintColor = .black
                    cell.textLabel?.text = "Settings"
                    cell.detailTextLabel?.text = "Settings"
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
}
