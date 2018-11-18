//
//  Trick.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation


struct Video: Codable {
    var youtube: String?
}

class Trick: Codable {
    
    var name: String
    var level: Int
    var videos: Video
    var description: String
    var type: String
    
}
