//
//  Trick.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase

struct BaseTrick: Codable, Identifiable {
    internal init(name: String, level: Int, type: String, levels: Levels? = nil, id: String? = nil) {
        self.name = name
        self.level = level
        self.type = type
        self.levels = levels
        self.id = id
    }

    let Id = UUID()
    var name: String
    var level: Int
    var type: String
    var levels: Levels?
    var id: String?


    
    init(data: [String : Any]) {
        guard let name = data["name"] as? String, let level = data["level"] as? Int, let type = data["type"] as? String else {
            fatalError("Deserialization error. Data missing")
        }
        
        self.name = name
        self.level = level
        self.type = type
        if let levelsData = data["levels"] as? [String : Any] {
            self.levels = Levels(levelsData)
        }
    }
}

extension BaseTrick: Hashable {
    static func == (lhs: BaseTrick, rhs: BaseTrick) -> Bool {
        lhs.Id == rhs.Id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(Id)
    }
}

struct Trick: Codable, Identifiable {
    var id: String?
    var name: String
    var videos: Video?
    var description: String
    var levels: Levels?
    var prerequisites: [Prerequisites]?
    
    init(_ data: [String: Any]) {
        self.name = (data["name"] as? String) ?? ""
        self.videos = Video(data: data)
        self.description = (data["description"] as? String) ?? ""
        self.levels = Levels((data["levels"] as? [String: Any]))
        let preres = data["prerequisites"] as? [[String: Any]]
        self.prerequisites = preres?.compactMap {
            let val = $0["id"] as? String
            return Prerequisites(val)
        }
    }
}

extension Trick: Hashable {
    static func == (lhs: Trick, rhs: Trick) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
    }
}

struct Video: Codable {
    var youtube: String

    init?(data: [String : Any]?) {
        guard let videos = data?["videos"] as? [String: Any] else {
            fatalError("Error with deserialize video")
        }
        self.youtube = (videos["youtube"] as? String) ?? ""
    }
}

struct Levels: Codable {
    var ijru: LevelsFields
    var irsf: LevelsFields
    var wjr: LevelsFields
    
    init?(_ levelsData: [String : Any]?) {
        if let ijru = levelsData?["ijru"] as? [String : Any] {
            self.ijru = LevelsFields(level: ijru["level"] as? String)
        } else if let ijru = levelsData?["ijru"] as? String {
            self.ijru = LevelsFields(level: ijru)
        } else {
            self.ijru = LevelsFields(level: nil)
        }
        if let irsf = levelsData?["irsf"] as? [String : Any] {
            self.irsf = LevelsFields(level: irsf["level"] as? String)
        } else {
            self.irsf = LevelsFields(level: nil)
        }
        if let wjr = levelsData?["wjr"] as? [String : Any] {
            self.wjr = LevelsFields(level: wjr["level"] as? String)
        } else {
            self.wjr = LevelsFields(level: nil)
        }
    }
}

struct LevelsFields: Codable {
    var level: String?
}

struct Prerequisites: Codable {
    var id: String
    
    init?(_ id: String?) {
        guard let id = id else { return nil }
        self.id = id
    }
    
    init?(_ data: [String: Any]) {
        if let prerequisites = data["prerequisites"] as? [String: Any] {
            self.id = (prerequisites["id"] as? String) ?? ""
        } else {
            return nil
        }
    }
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
