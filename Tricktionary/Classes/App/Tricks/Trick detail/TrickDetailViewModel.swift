//
//  TrickDetailViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import ReactiveSwift

class TrickDetailViewModel {
    
    
    // MARK: Variables
    
    var trick: Trick?
    var trickName: String
    var loaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
    var loadedPrerequisites: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    // MARK: Life cycles
    
    init(trick: String) {
        self.trickName = trick
    }
    
    // MARK: Public
    
    func getTrick() {
        TrickService().getTrickByName(name: trickName) { (trick) in
            self.trick = Trick(trick)
            self.trick?.getPrerequisites(finish: {
                self.loadedPrerequisites.value = true
            })
            self.loaded.value = true
        }
    }
}
