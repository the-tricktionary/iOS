//
//  SpeedDataViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 22/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import ReactiveSwift

class SpeedDataViewModel {
    
    // MARK: Variables
    
    var speeds: [Speed] = [Speed]()
    var isLoaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    // MARK: Public
    
    func getSpeedData(starting: @escaping () -> Void, finish: @escaping () -> Void) {
        SpeedManager.shared.getSpeedData(starting: {
            starting()
        }, completion: { (speed) in
            self.speeds.append(speed)
        }) {
            finish()
        }
    }
}
