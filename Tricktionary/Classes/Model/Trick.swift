//
//  Trick.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase

class Trick {
    
    // MARK: Variables
    
    var name: String
    var level: Int
    var videos: Video
    var description: String
    var type: String
    var levels: Levels
    var prerequisites: [String] = []
    
    fileprivate var data: [String : Any]
    
    
    init(_ data: [String : Any]) {
        self.data = data
        level = data["level"] as! Int
        name = data["name"] as! String
        description = data["description"] as! String
        type = data["type"] as! String
        videos = Video(data["videos"] as! [String : Any])
        levels = Levels(data["levels"] as! [String : Any])
    }
    
    // MARK: Public
    
    func getPrerequisites(finish: @escaping () -> Void) {
        if let prerequisitesData = data["prerequisites"] as? [[String : Any]] {
            prerequisitesData.forEach { (prerequisite) in
                if let id = prerequisite["id"] as? String {
                    TrickService().getTrickNameById(id: id, completion: { (data) in
                        self.prerequisites.append(data["name"] as! String)
                        finish()
                    })
                }
            }
        }
    }
}

struct Video: Codable {
    
    // MARK: Variables
    
    var youtube: String
    
    // MARK: Life cycle
    
    init (_ data: [String : Any]) {
        youtube = data["youtube"] as! String
    }
}

struct Levels: Codable {
    
    // MARK: Variables
    
    var irsf: LevelsFields
    var wjr: LevelsFields
    
    // MARK: Life cycles
    
    init(_ data: [String : Any]) {
        irsf = LevelsFields(data["irsf"] as! [String : Any])
        wjr = LevelsFields(data["wjr"] as! [String : Any])
    }
}

struct LevelsFields: Codable {
    
    // MARK: Variables
    
    var level: String?
    
    // MARK: Life cycles
    
    init(_ data: [String : Any]) {
        level = data["level"] as? String
    }
}
