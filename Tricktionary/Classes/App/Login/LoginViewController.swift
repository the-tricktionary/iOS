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
import ReactiveSwift
import ReactiveCocoa
import SwiftUI

struct LoginVC: UIViewControllerRepresentable {
    var onClose: (() -> Void)?

    func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVC>) -> LoginViewController {
        let vc = LoginViewController(viewModel: LoginViewModel())
        vc.onClose = {
            onClose?()
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: LoginViewController, context: UIViewControllerRepresentableContext<LoginVC>) {
        //
    }
}

class LoginViewController: BaseCenterViewController, GIDSignInDelegate {
    
    // MARK: Variables
    
    fileprivate let contentView: UIView = UIView()
    fileprivate let loginView: LoginView = LoginView()
    fileprivate let registrationView: RegistrationView = RegistrationView()
    let viewModel: LoginViewModel
    var onClose: (() -> Void)?
    
    // MARK: Life cycles
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(contentView)
        contentView.addSubview(loginView)
        contentView.addSubview(registrationView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        view.backgroundColor = UIColor.white
        
        title = "Login"
        
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        loginView.signInButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        loginView.registrationLabel.isUserInteractionEnabled = true
        let registrationGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showRegistration))
        loginView.registrationLabel.addGestureRecognizer(registrationGestureRecognizer)
        
        viewModel.loginEmail <~ loginView.emailTextField.textField.reactive.continuousTextValues
        viewModel.loginPassword <~ loginView.passwordTextField.textField.reactive.continuousTextValues
        
        loginView.emailTextField.textField.reactive.continuousTextValues.observeValues { [weak self] (value) in
            self?.loginView.emailTextField.warningFormat.isHidden = self?.viewModel.isValidEmail(email: value) ?? false
        }
        
        loginView.passwordTextField.textField.reactive.continuousTextValues.observeValues { [weak self] (value) in
            self?.loginView.passwordTextField.warningFormat.isHidden = self?.viewModel.isValidPassword(password: value) ?? false
        }
        
        loginView.signInButton.reactive.isEnabled <~ viewModel.isLoginEnabled
        
        registrationView.emailTextField.textField.reactive.continuousTextValues.observeValues { [weak self] (value) in
            self?.registrationView.emailTextField.warningFormat.isHidden = self?.viewModel.isValidEmail(email: value) ?? false
        }
        
        registrationView.passwordTextField.textField.reactive.continuousTextValues.observeValues { [weak self] (value) in
            self?.registrationView.passwordTextField.warningFormat.isHidden = self?.viewModel.isValidPassword(password: value) ?? false
        }
        
        registrationView.repeatPasswordTextField.textField.reactive.continuousTextValues.observeValues { [weak self] (value) in
            self?.registrationView.repeatPasswordTextField.warningFormat.isHidden = self?.viewModel.isValidPassword(password: value) ?? false
        }
        
        viewModel.registrationEmail <~ registrationView.emailTextField.textField.reactive.continuousTextValues
        viewModel.registrationPassword <~ registrationView.passwordTextField.textField.reactive.continuousTextValues
        viewModel.registrationPasswordCheck <~ registrationView.repeatPasswordTextField.textField.reactive.continuousTextValues

        
        registrationView.signUpButton.reactive.isEnabled <~ viewModel.isRegistrationEnabled
        
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
        viewModel.login(failed: { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }, completed: {
            self.navigationController?.dismiss(animated: true, completion: nil)
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
        viewModel.register(failed: { (error) in
            let alert = UIAlertController(title: "Error",
                                          message: "Signing up failed",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }) {
        }
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error while sign in with google \(error.localizedDescription)")
                return
            }
            self.onClose?()
        }
    }

    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
