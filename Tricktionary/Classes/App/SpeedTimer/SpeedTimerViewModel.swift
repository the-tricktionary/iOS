//
//  SpeedTimerViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 20/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import AVFoundation

class SpeedTimerViewModel {
    
    // MARK: Variables
    
    fileprivate let speedTimes: SpeedTimes = SpeedTimes()
    fileprivate let speedEvents: SpeedEvents = SpeedEvents()
    var times: [Int : Int]
    var events: [Int : String]
    
    // MARK: Life cycles
    
    init() {
        self.times = speedTimes.data
        self.events = speedEvents.data
    }
    
    // MARK: Public
    
    func timeFormatted(_ field: Int) -> String {
        let totalSeconds = speedTimes.data[field]
        let seconds: Int = totalSeconds! % 60
        let minutes: Int = (totalSeconds! / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
