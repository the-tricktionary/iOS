//
//  TricksViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ReactiveSwift

class TricksViewModel {
    
    var level1: MutableProperty<[Trick]> = MutableProperty<[Trick]>([])
    var level2: MutableProperty<[Trick]> = MutableProperty<[Trick]>([])
    var level3: MutableProperty<[Trick]> = MutableProperty<[Trick]>([])
    var level4: MutableProperty<[Trick]> = MutableProperty<[Trick]>([])
    var level5: MutableProperty<[Trick]> = MutableProperty<[Trick]>([])
    
    // MARK: Variables
    
    // MARK: Life cycles
    
    // MARK: Privates
    
    // MARK: Publics
    
    func getTricks() {
        TrickService().getTricksByLevel(level: Level.level1.rawValue, tricks: &level1)
        TrickService().getTricksByLevel(level: Level.level2.rawValue, tricks: &level2)
        TrickService().getTricksByLevel(level: Level.level3.rawValue, tricks: &level3)
        TrickService().getTricksByLevel(level: Level.level4.rawValue, tricks: &level4)
        TrickService().getTricksByLevel(level: Level.level5.rawValue, tricks: &level5)
    }
    
}
