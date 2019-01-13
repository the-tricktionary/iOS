//
//  LoginViewController.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class LoginViewController: MenuItemViewController, GIDSignInUIDelegate {
    
    // MARK: Variables
    
    let signInButton: GIDSignInButton = GIDSignInButton()
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(signInButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Login"
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "list"),
                                         style: .plain,
                                         target: self, action: #selector(menuTapped))
        navigationItem.leftBarButtonItem = menuButton
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        signInButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(150)
        }
    }
    
    // MARK: User action
    
    @objc func menuTapped() {
        delegate?.toggleMenu()
    }
}
