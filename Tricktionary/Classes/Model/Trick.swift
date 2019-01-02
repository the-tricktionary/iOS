//
//  Trick.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation

class Trick: Codable {
    
    // MARK: Variables
    
    var name: String
//    var level: Int
    var videos: Video
    var description: String
    var type: String
    var levels: Levels
    
    init(_ data: [String : Any]) {
        name = data["name"] as! String
        description = data["description"] as! String
        type = data["type"] as! String
        videos = Video(data["videos"] as! [String : Any])
        levels = Levels(data["levels"] as! [String : Any])
    }
    
    
    //var prerequisites: [Prerequisite]?
    //var levels: Levels
    
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

struct Prerequisite: Codable {
    var name: String
}
