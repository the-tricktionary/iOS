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

class SidePanelDelegate: NSObject, UITableViewDelegate {
    
    var viewController: SidePanelViewController!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Auth.auth().currentUser != nil {
            // Loged in
            
            if indexPath.row == 2 {
                viewController.delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
            } else if indexPath.row == 3 {
                // TODO: Speed timer
            } else if indexPath.row == 4 {
                // TODO: Speed data
            } else if indexPath.row == 5 {
                // TODO: Submit
            } else if indexPath.row == 6 {
                viewController.openInstagram()
            } else if indexPath.row == 7 {
                guard let url = URL(string: Constatnts.websiteUrl) else { return }
                UIApplication.shared.open(url)
            } else if indexPath.row == 8 {
                // TODO: Contact
            } else if indexPath.row == 9 {
                // TODO: Writer
            } else if indexPath.row == 10 {
                // TODO: Settings
            } else if indexPath.row == 11 {
                let auth = Auth.auth()
                do {
                    try auth.signOut()
                } catch {
                    print("Error: \(error.localizedDescription)") // TODO: Alert
                }
                viewController.delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
            }
            
        } else {
            if indexPath.row == 0 {
                viewController.delegate?.didSelectMenuItem(viewController: LoginViewController())
            } else if indexPath.row == 2 {
                viewController.delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
            } else if indexPath.row == 3 {
                // TODO: Speed timer
            } else if indexPath.row == 4 {
                viewController.openInstagram()
            } else if indexPath.row == 5 {
                guard let url = URL(string: Constatnts.websiteUrl) else { return }
                UIApplication.shared.open(url)
            } else if indexPath.row == 6 {
                // TODO: Settings
            }
        }
    }
}
