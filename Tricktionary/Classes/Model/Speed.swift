//
//  Speed.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 22/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase

class Speed: Codable {
    
    // MARK: Variables
    var avgJumps: Double = 0.0
    var created: Date?
    var event: String?
    var jumpsLost: Int = 0
    var maxJumps: Double = 0
    var misses: Int = 0
    var name: String? = ""
    var noMissScore: Int = 0
    var score: Int = 0
    var duration: Int = 0
    var uid: String = ""
    var graphData: [Double] = [Double]()
    var speedId: String = ""
    
    init(data: [String: Any]) {
        name = data["name"] as? String
        created = data["created"] as? Date
        event = data["event"] as? String
        avgJumps = data["avgJumps"] as? Double ?? 0
        jumpsLost = data["jumpsLost"] as? Int ?? 0
        maxJumps = data["maxJumps"] as? Double ?? 0
        misses = data["misses"] as? Int ?? 0
        noMissScore = data["noMissScore"] as? Int ?? 0
        score = data["score"] as? Int ?? 0
        duration = data["duration"] as? Int ?? 0
        graphData = data["graphData"] as? [Double] ?? [Double]()
        uid = data["uid"] as? String ?? ""
    }
    
    func getDictionary() -> [String: Any] {
        Mirror(reflecting: self).children.reduce(into: [:]) { (result, data) in
            result[data.label ?? ""] = data.value
        }
    }
}
