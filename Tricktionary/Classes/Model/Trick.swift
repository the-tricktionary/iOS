//
//  Trick.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase

class Trick: Codable {
    
    // MARK: Variables
    
    var name: String
    var level: Int
    var videos: Video?
    var description: String
    var type: String
    var levels: Levels?
    var prerequisites: [Prerequisites]?
}

struct Video: Codable {
    var youtube: String
}

struct Levels: Codable {
    var irsf: LevelsFields
    var wjr: LevelsFields
}

struct LevelsFields: Codable {
    var level: String?
}

struct Prerequisites: Codable {
    var id: String
}
