//
//  LoginView.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 15/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class LoginView: UIView {
    
    // MARK: Variables
    
    let emailTextField = IconTextField()
    let passwordTextField = IconTextField()
    let signInButton = GradientButton()
    let registrationLabel = UILabel()
    let alternativeLabel: UILabel = UILabel()
    let googleSignButton: GIDSignInButton = GIDSignInButton()
    
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
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
        addSubview(registrationLabel)
        addSubview(alternativeLabel)
        addSubview(googleSignButton)
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
        
        signInButton.setTitle("Sign In", for: .normal)
        
        registrationLabel.text = "Registration"
        registrationLabel.textColor = UIColor.red
        registrationLabel.font = UIFont.boldSystemFont(ofSize: 22)
        registrationLabel.isUserInteractionEnabled = true
        
        alternativeLabel.text = "Or you can use google account to sign in"
        alternativeLabel.textColor = UIColor.black
        alternativeLabel.font = UIFont.systemFont(ofSize: 14)
        alternativeLabel.numberOfLines = 2
        alternativeLabel.textAlignment = .center
        
        googleSignButton.layer.cornerRadius = 4
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
        
        signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(50)
        }
        
        registrationLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(signInButton.snp.bottom).offset(24)
            make.height.equalTo(30)
        }
        
        alternativeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(registrationLabel.snp.bottom).offset(10)
            make.leading.equalTo(signInButton)
            make.trailing.equalTo(signInButton)
            make.height.equalTo(28)
        }
        
        googleSignButton.snp.makeConstraints { (make) in
            make.top.equalTo(alternativeLabel.snp.bottom).offset(5)
            make.leading.equalTo(signInButton)
            make.trailing.equalTo(signInButton)
            make.height.equalTo(50)
        }
    }
}
