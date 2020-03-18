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
}

struct Trick: Codable {
    var name: String
    var videos: Video?
    var description: String
    var levels: Levels?
    var prerequisites: [Prerequisites]?

    init?(data: [String : Any]) {
        guard let _name = data["name"] as? String,
            let _videos = Video(data: data["videos"] as? [String : Any]),
              let _description = data["description"] as? String else {
                fatalError("Error with deserialize trick")
        }
        self.name = _name
        self.videos = _videos
        self.description = _description

        self.levels = data["levels"] as? Levels
        if let prerequisites = data["prerequisites"] as? [String : Any] {
            self.prerequisites == nil ?
                self.prerequisites = [Prerequisites(id: prerequisites["id"] as? String ?? "")] :
                self.prerequisites?.append(Prerequisites(id: prerequisites["id"] as? String ?? ""))
        }
    }
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
