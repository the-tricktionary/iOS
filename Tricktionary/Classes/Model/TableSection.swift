//
//  TableSection.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 12/05/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation


class Section {
    
    // MARK: Variables
    
    var name: String
    var items: [Any]
    var collapsed: Bool
    
    // MARK: Initializers
    
    init(name: String, items: [Any], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
    
    
}
