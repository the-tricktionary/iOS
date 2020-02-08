//
//  TricksTableSection.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 25/01/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation

struct TableSection {
    var name: String
    var rows: [TrickLevelCell.Content]
    var collapsed: Bool
    var tricks: Int
    var completed: Int?
}
