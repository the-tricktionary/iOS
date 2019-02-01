//
//  RegistrationView.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 15/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class RegistrationView: UIView {
    
    // MARK: Variables
    
    let emailTextField = IconTextField()
    let passwordTextField = IconTextField()
    let repeatPasswordTextField = IconTextField()
    let signUpButton = GradientButton()
    let signInLabel = UILabel()
    
    // MARK: Life cycles
    
    required init() {
        super.init(frame: .zero)
        setupSubviews()
        setupViewConstraints()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    fileprivate func setupSubviews() {
        addSubview(repeatPasswordTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
        addSubview(signInLabel)
    }
    
    fileprivate func setup() {
        emailTextField.textField.placeholder = "E-mail"
        emailTextField.icon.image = UIImage(named: "emailIcon")
        emailTextField.warningFormat.text = "Invlaid e-mail format"
        emailTextField.warningFormat.isHidden = true
        
        passwordTextField.textField.placeholder = "Password"
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.icon.image = UIImage(named: "passwordIcon")
        passwordTextField.warningFormat.text = "Invalid password format"
        passwordTextField.warningFormat.isHidden = true
        
        repeatPasswordTextField.textField.placeholder = "Password check"
        repeatPasswordTextField.textField.isSecureTextEntry = true
        repeatPasswordTextField.icon.image = UIImage(named: "passwordIcon")
        repeatPasswordTextField.warningFormat.text = "Invalid password format"
        repeatPasswordTextField.warningFormat.isHidden = true
        
        
        signUpButton.setTitle("Sign Up", for: .normal)
        
        signInLabel.text = "Sign In"
        signInLabel.textColor = UIColor.red
        signInLabel.font = UIFont.boldSystemFont(ofSize: 22)
        signInLabel.isUserInteractionEnabled = true
    }
    
    fileprivate func setupViewConstraints() {
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(30)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(25)
            make.leading.equalTo(emailTextField)
            make.trailing.equalTo(emailTextField)
            make.height.equalTo(30)
        }
        
        repeatPasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
            make.leading.equalTo(passwordTextField)
            make.trailing.equalTo(passwordTextField)
            make.height.equalTo(30)
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(24)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(50)
        }
        
        signInLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(signUpButton.snp.bottom).offset(24)
            make.height.equalTo(30)
        }
    }
}
