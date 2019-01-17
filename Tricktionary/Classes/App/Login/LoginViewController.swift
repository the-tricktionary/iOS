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
import Firebase

class LoginViewController: MenuItemViewController, GIDSignInUIDelegate {
    
    // MARK: Variables
    
    fileprivate let contentView: UIView = UIView()
    fileprivate let loginView: LoginView = LoginView()
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(contentView)
        contentView.addSubview(loginView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Login"
        
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        loginView.signInButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        setupViewConstraints()
    }
    
    // MARK: Privates
    
    fileprivate func setupViewConstraints() {
        
        contentView.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.centerY.equalTo(view)
            make.height.equalTo(350)
        }
        
        loginView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(33)
            make.leading.equalTo(contentView).offset(25)
            make.trailing.equalTo(contentView).offset(-25)
            make.bottom.equalTo(contentView).offset(-24)
        }
    }
    
    // MARK: User action
    
    // TODO: Alert if login failed, on success redirect
    @objc func loginTapped() {
        Auth.auth().signIn(withEmail: loginView.emailTextField.textField.text ?? "",
                           password: loginView.passwordTextField.textField.text ?? "",
                           completion: { (user, error) in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                let alert = UIAlertController(title: "Error",
                                                              message: "Signing in failed",
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                                self.present(alert, animated: true)
                                return
                            }
                            self.delegate?.toggleMenu()
                            print("User: \(user?.displayName) is signed in")
        })
    }
}
