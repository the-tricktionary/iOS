//
//  UserManager.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 02/08/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseAuth
import ReactiveSwift

public protocol UserManagerType {
    var isLogged: Bool { get }
    
}

class UserManager: UserManagerType {
    
    var isLogged: Bool {
        return Auth.auth().currentUser != nil
    }
    
    public static var shared: UserManager {
        return UserManager()
    }
}
