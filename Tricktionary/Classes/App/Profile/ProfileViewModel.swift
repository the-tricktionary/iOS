//
//  ProfileViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 08/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseAuth

class ProfileViewModel {
    
    // MARK: Variables
    
    // MARK: Initializers
    
    // MARK: Public
    
    func getUserPhotoURL() -> Data? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        var data: Data?
        
        if let userImageURL = user.photoURL {
            do {
                data = try Data(contentsOf: userImageURL)
            } catch {
                return nil
            }
        }
        
        return data
    }
    
    func getUserInfo() -> [String : String?] {
        guard let user = Auth.auth().currentUser else { return [String : String?]() }
        
        var userInfo: [String : String?] = [String : String?]()
        
        userInfo["name"] = user.displayName
        userInfo["email"] = user.email
        
        return userInfo
    }
}
