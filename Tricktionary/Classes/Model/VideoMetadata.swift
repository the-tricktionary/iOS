//
//  VideoMetadata.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 09/04/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation

class VideoMetadata {
    
    var name: String = ""
    var email: String = ""
    var uid: String = ""
    
    var trickName: String = ""
    var desc: String = ""
    var trickType: String = ""
    
    func asDisctionary() -> [String : Any] {
        var dictionary = [String : Any]()
        
        dictionary["name"] = self.name
        dictionary["email"] = self.email
        dictionary["uid"] = self.uid
        dictionary["trickName"] = self.trickName
        dictionary["trickType"] = self.trickType
        dictionary["desc"] = self.desc
        
        return dictionary
    }
    
    func isValid() -> Bool {
        return !trickName.isEmpty &&
                !desc.isEmpty &&
                !trickType.isEmpty
        
    }
}
