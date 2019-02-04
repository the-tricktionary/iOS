//
//  LoginViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 02/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import ReactiveSwift
import FirebaseAuth

class LoginViewModel {
    
    // MARK: Variables
    
    let isLoginEnabled: MutableProperty<Bool> = MutableProperty<Bool>(false)
    let isRegistrationEnabled: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    let loginEmail: MutableProperty<String?> = MutableProperty<String?>(nil)
    let loginPassword: MutableProperty<String?> = MutableProperty<String?>(nil)
    
    let registrationEmail: MutableProperty<String?> = MutableProperty<String?>(nil)
    let registrationPassword: MutableProperty<String?> = MutableProperty<String?>(nil)
    let registrationPasswordCheck: MutableProperty<String?> = MutableProperty<String?>(nil)
    
    // MAKR: Life cycles
    
    init() {
        isLoginEnabled <~ SignalProducer.combineLatest(loginEmail.producer, loginPassword.producer).map {
            (arg) -> Bool in
            
            let (email, password) = arg
            return self.isValidEmail(email: email)
                && self.isValidPassword(password: password)
        }
        
        isRegistrationEnabled <~ SignalProducer.combineLatest(registrationEmail.producer,
                                                              registrationPassword.producer,
                                                              registrationPasswordCheck.producer).map {
                                                                (arg) -> Bool in
                                                                let (email, password, passwordCheck) = arg
                                                                return self.isValidEmail(email: email)
                                                                    && self.isValidPassword(password: password)
                                                                    && self.isValidPassword(password: passwordCheck)
        }
    }
    
    // MARK: Public
    
    func login(failed: @escaping (Error) -> Void, completed: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: loginEmail.value ?? "",
                           password: loginPassword.value ?? "",
                           completion: { (user, error) in
                            if let error = error {
                                failed(error)
                                return
                            }
                            completed()
        })
    }
    
    func register(failed: @escaping (Error) -> Void, completed: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: registrationEmail.value!,
                               password: registrationPassword.value!,
                               completion: { (user, error) in
                                if let _ = error {
                                    failed(error!)
                                }
                                completed()
        })
    }
    
    func isValidEmail(email: String?) -> Bool {
        return validateEmail(email)
    }
    
    func isValidPassword(password: String?) -> Bool {
        return validatePassword(password)
    }
    
    // MAKR: Privates
    
    fileprivate func validateEmail(_ emaiString: String?) -> Bool {
        
        if let email = emaiString {
            let regex = try! NSRegularExpression(pattern:
                "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}", options: .caseInsensitive)
            if regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil {
                return true
            }
        }
        
        return false
    }
    
    fileprivate func validatePassword(_ passwordString: String?) -> Bool {
        if let password = passwordString {
            let regex = try! NSRegularExpression(pattern:
                "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$", options: .caseInsensitive)
            if regex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) != nil {
                return true
            }
        }
        
        return false
    }
}
