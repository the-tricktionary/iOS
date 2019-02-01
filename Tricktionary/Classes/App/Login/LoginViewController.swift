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
    fileprivate let registrationView: RegistrationView = RegistrationView()
    
    // MARK: Life cycles
    
    override func loadView() {
        super.loadView()
        view.addSubview(contentView)
        contentView.addSubview(loginView)
        contentView.addSubview(registrationView)
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
        
        loginView.registrationLabel.isUserInteractionEnabled = true
        let registrationGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showRegistration))
        loginView.registrationLabel.addGestureRecognizer(registrationGestureRecognizer)
        
        registrationView.isHidden = true
        registrationView.signUpButton.isUserInteractionEnabled = true
        registrationView.signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        registrationView.signInLabel.isUserInteractionEnabled = true
        let loginLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showLogin))
        registrationView.signInLabel.addGestureRecognizer(loginLabelGestureRecognizer)
        
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
        
        registrationView.snp.makeConstraints { (make) in
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
        })
    }
    
    @objc func signUpTapped() {
        if registrationView.passwordTextField.textField.text !=
            registrationView.repeatPasswordTextField.textField.text {
            let alert = UIAlertController(title: "Error",
                                          message: "Passwords are different",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        Auth.auth().createUser(withEmail: registrationView.emailTextField.textField.text!,
                               password: registrationView.passwordTextField.textField.text!,
                               completion: { (user, error) in
                                if let _ = error {
                                    let alert = UIAlertController(title: "Error",
                                                                  message: "Signing Up failed",
                                                                  preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                                    self.present(alert, animated: true)
                                    return
                                }
                                self.delegate?.toggleMenu()
        })
    }
    
    @objc func showRegistration() {
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(320)
        }
        loginView.isHidden = true
        registrationView.isHidden = false
    }
    
    @objc func showLogin() {
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(350)
        }
        loginView.isHidden = false
        registrationView.isHidden = true
    }
}
