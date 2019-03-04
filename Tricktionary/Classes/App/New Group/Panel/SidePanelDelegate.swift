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
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if Auth.auth().currentUser == nil {
                if indexPath.row == 0 {
                    delegate?.didSelectMenuItem(viewController: LoginViewController(viewModel: LoginViewModel()))
                }
            }
        }
        
        if Auth.auth().currentUser != nil {
            // Loged in
            
            if indexPath.row == 1 {
                delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
            } else if indexPath.row == 2 {
                delegate?.didSelectMenuItem(viewController: SpeedTimerViewController(viewModel: SpeedTimerViewModel()))
            } else if indexPath.row == 3 {
                delegate?.didSelectMenuItem(viewController: SpeedDataViewController(viewModel: SpeedDataViewModel()))
            } else if indexPath.row == 4 {
                // TODO: Submit
            } else if indexPath.row == 5 {
                openInstagram()
            } else if indexPath.row == 6 {
                guard let url = URL(string: Constatnts.websiteUrl) else { return }
                UIApplication.shared.open(url)
            } else if indexPath.row == 7 {
                // TODO: Contact
            } else if indexPath.row == 8 {
                // TODO: Writer
            } else if indexPath.row == 9 {
                delegate?.didSelectMenuItem(viewController: SettingsViewController())
            } else if indexPath.row == 10 {
                let auth = Auth.auth()
                do {
                    try auth.signOut()
                } catch {
                    print("Error: \(error.localizedDescription)") // TODO: Alert
                }
                delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
            }
            
        } else {
            if indexPath.row == 1 {
                delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
            } else if indexPath.row == 2 {
                delegate?.didSelectMenuItem(viewController: SpeedTimerViewController(viewModel: SpeedTimerViewModel()))
            } else if indexPath.row == 3 {
                openInstagram()
            } else if indexPath.row == 4 {
                guard let url = URL(string: Constatnts.websiteUrl) else { return }
                UIApplication.shared.open(url)
            } else if indexPath.row == 5 {
                delegate?.didSelectMenuItem(viewController: SettingsViewController())
            }
        }
    }
}
