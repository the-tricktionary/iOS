//
//  SidePanelDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 14
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if Auth.auth().currentUser == nil {
                let loginVC = LoginViewController(viewModel: LoginViewModel())
                loginVC.onClose = { [weak self] in
                    self?.tableView.reloadData()
                }
                navigationController?.present(loginVC, animated: true, completion: nil)
            } else {
                navigationController?.present(ProfileViewController(viewModel: ProfileViewModel()), animated: true, completion: nil)
            }
        } else if indexPath.section == 1 {
            if Auth.auth().currentUser != nil {
                // Loged in
                if indexPath.row == 1 {
                    openInstagram()
                } else if indexPath.row == 2 {
                    guard let url = URL(string: Constatnts.websiteUrl) else { return }
                    UIApplication.shared.open(url)
                } else if indexPath.row == 3 {
                    // TODO: Contact
                } else if indexPath.row == 4 {
                    // TODO: Writer
                } else if indexPath.row == 5 {
                    navigationController?.present(SettingsViewController(), animated: true, completion: nil)
                } else if indexPath.row == 6 {
                    let auth = Auth.auth()
                    do {
                        try auth.signOut()
                    } catch {
                        print("Error: \(error.localizedDescription)") // TODO: Alert
                    }
                    tableView.reloadData()
                }
                
            } else {
                if indexPath.row == 1 {
                    openInstagram()
                } else if indexPath.row == 2 {
                    guard let url = URL(string: Constatnts.websiteUrl) else { return }
                    UIApplication.shared.open(url)
                } else if indexPath.row == 3 {
                    navigationController?.present(SettingsViewController(), animated: true, completion: nil)
                }
            }
        }
    }
}
