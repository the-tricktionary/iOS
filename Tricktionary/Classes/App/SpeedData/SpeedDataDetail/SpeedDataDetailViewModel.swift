//
//  SpeedDataDetailViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation

class SpeedDataDetailViewModel {
    
    // MARK: Variables
    
    var speedData: Speed
    
    // MARK: Life cycle
    
    init(speedData: Speed) {
        self.speedData = speedData
    }
    
    // MARK: Public
    
    func getMirror() -> Mirror {
        return Mirror(reflecting: speedData)
    }
    
    func getSpeedChartData() -> [(x: Double, y: Double)] {
        var data = [(x: Double, y: Double)]()
        
        return data
    }
}
