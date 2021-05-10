//
//  UserManager.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 02/08/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

public protocol UserManagerType {
    var userStateDidChange: PassthroughSubject<Bool, Never> { get }
    var userName: String? { get }
    var email: String? { get }
    var userId: String? { get }
    var logged: Bool { get }
    var imageData: Data? { get }
    
    func logout()
}

class UserManager: UserManagerType {
    
    // MARK: - Variables
    var userStateDidChange = PassthroughSubject<Bool, Never>()
    var logged: Bool {
        Auth.auth().currentUser != nil
    }
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    var userName: String? {
        Auth.auth().currentUser?.displayName
    }
    
    var imageData: Data? {
        guard let url = Auth.auth().currentUser?.photoURL else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
    var email: String? {
        Auth.auth().currentUser?.email
    }
    
    // MARK: - Initializer
    init() {
        bind()
    }
    
    // MAKR: - Public
    func logout() {
        do {
            try Auth.auth().signOut()
            userStateDidChange.send(true)
        } catch {
            print("### Logout error \(error)")
        }
    }
    // MARK: - Privates
    private func bind() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userStateDidChange.send(user != nil)
        }
    }
}
