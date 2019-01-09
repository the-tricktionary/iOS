//
//  BaseViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class BaseContentViewController: UIViewController {
    
    
    // MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.isTranslucent = false
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "list"),
                                         style: .done,
                                         target: self,
                                         action: #selector(toogleMenu))
        
        navigationItem.leftBarButtonItem = menuButton
    }
    
    // MARK: User actions
    
    @objc func toogleMenu() {
        sideMenuController?.revealMenu()
    }
}
