//
//  SpeedDataViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 22/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import ReactiveSwift
import Combine

class SpeedDataViewModel: ObservableObject {
    
    // MARK: Variables
    
    @Published var speeds: [Speed] = []
    var isLoaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    // MARK: Public
    
    func getSpeedData(starting: @escaping () -> Void, finish: @escaping () -> Void) {
        var data: [Speed] = []
        SpeedManager.shared.getSpeedData(starting: {
            starting()
        }, completion: { (speed) in
            data.append(speed)
            self.speeds.append(speed)
        }) {
            self.speeds = data
            finish()
        }
    }
}
