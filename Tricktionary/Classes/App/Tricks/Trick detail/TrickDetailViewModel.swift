//
//  TrickDetailViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation

class TrickDetailViewModel {
    
    
    // MARK: Variables
    
    var trick: Trick
    
    // MARK: Life cycles
    
    init(trick: Trick) {
        self.trick = trick
    }
}
