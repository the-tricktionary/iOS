//
//  LoginViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: MenuItemViewController {
    
    // MARK: Variables
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Login"
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "list"),
                                         style: .plain,
                                         target: self, action: #selector(menuTapped))
        navigationItem.leftBarButtonItem = menuButton
        
        if let del = delegate {
            print("MAM DELEGATA")
        } else {
            print("NEMAM DELEGATA")
        }
    }
    
    // MARK: User action
    
    @objc func menuTapped() {
        delegate?.toggleMenu()
    }
}
