//
//  Level.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 22/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation

class TrickTypes: Codable {
    
    var basics: [Trick] = []
    var multiples: [Trick] = []
    var powers: [Trick] = []
    var manipulations: [Trick] = []
    var releases: [Trick] = []
    var impossibles: [Trick] = []
}
