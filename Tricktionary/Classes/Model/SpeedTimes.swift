//
//  SpeedTimes.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 18/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation

class SpeedTimes {
    
    var data: [Int : Int]
    
    init() {
        data = [
            0: 30,
            1: 60,
            2: 120,
            3: 180
            ] as [Int : Int]
    }
    
    func timeFormatted(_ field: Int) -> String {
        let totalSeconds = data[field]
        return DateTimeUtil.timeFormatted(totalSeconds!)
    }
}
