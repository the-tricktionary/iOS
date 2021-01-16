//
//  SpeedEvents.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation

struct SpeedEvent: Codable {
    let name: String
    let periods: Int
    let checkpoints: Int
}

extension SpeedEvent: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(periods)
        hasher.combine(checkpoints)
    }
}
