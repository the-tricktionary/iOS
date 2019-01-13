//
//  SidePanelDelegate.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class SidePanelDelegate: NSObject, UITableViewDelegate {
    
    var viewController: SidePanelViewController!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            viewController.delegate?.didSelectMenuItem(viewController: LoginViewController())
        } else if indexPath.row == 1 {
            viewController.delegate?.didSelectMenuItem(viewController: TricksViewController(viewModel: TricksViewModel()))
        } else if indexPath.row == 5 {
            let url: URL? = URL(string: Constatnts.instagramApp)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
            } else {
                //redirect to safari because the user doesn't have Instagram
                UIApplication.shared.open(NSURL(string: Constatnts.instagram)! as URL)
            }
        } else if indexPath.row == 6 {
            guard let url = URL(string: Constatnts.websiteUrl) else { return }
            UIApplication.shared.open(url)
        }
        
    }
}
