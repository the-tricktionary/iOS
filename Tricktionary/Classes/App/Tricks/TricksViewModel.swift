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
    
    // MARK: Variables
    
    var isLoaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    var trickList: MutableProperty<TrickList> = MutableProperty<TrickList>(TrickList())
    
    // MARK: Publics
    
    func getTricks() {
        TrickService().getTricksByLevel(completion: { (data) in
            self.trickList.value.addTrick(data: data)
        }) {
            self.isLoaded.value = true
        }
    }
    
}
