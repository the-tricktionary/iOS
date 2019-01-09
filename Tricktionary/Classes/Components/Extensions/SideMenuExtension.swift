//
//  SideMenuExtension.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import SideMenuSwift

extension SideMenuController {
    
    func setContentViewController(contentViewController: UIViewController, animation: Bool, completion: (() -> Void)? = nil) {
        
        let navigationController = UINavigationController(rootViewController: contentViewController)
        setContentViewController(to: navigationController, animated: animation, completion: completion)
    }
}
