//
//  Trick.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase

struct BaseTrick: Codable {
    var name: String
    var level: Int
    var type: String
    var levels: Levels?
    var id: String?
}

struct Trick: Codable {
    var id: String?
    var name: String
    var videos: Video?
    var description: String
    var levels: Levels?
    var prerequisites: [Prerequisites]?
}

struct Video: Codable {
    var youtube: String

    init?(data: [String : Any]?) {
        guard let _youtube = data?["youtube"] as? String else {
            fatalError("Error with deserialize video")
        }
        self.youtube = _youtube
    }
}

struct Levels: Codable {
    var ijru: LevelsFields
    var irsf: LevelsFields
    var wjr: LevelsFields
}

struct LevelsFields: Codable {
    var level: String?
}

struct Prerequisites: Codable {
    var id: String
}

enum Type: String {
    case basic, multiple, manipulation, power, release, impossible

    var name: String {
        switch self {
        case .basic:
            return "Basic"
        case .multiple:
            return "Multiple"
        case .manipulation:
            return "Manipulation"
        case .power:
            return "Power"
        case .release:
            return "Release"
        case .impossible:
            return "Impossible"
        }
    }
}
