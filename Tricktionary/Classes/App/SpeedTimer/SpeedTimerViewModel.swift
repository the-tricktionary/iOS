//
//  SpeedTimerViewModel.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 20/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import AVFoundation
import FirebaseAuth

class SpeedTimerViewModel {
    
    // MARK: Variables
    
    fileprivate let speedTimes: SpeedTimes = SpeedTimes()
    fileprivate let speedEvents: SpeedEvents = SpeedEvents()
    var times: [Int : Int]
    var events: [Int : String]
    var speed: Speed = Speed(data: [String: Any]())
    
    // MARK: Life cycles
    
    init() {
        self.times = speedTimes.data
        self.events = speedEvents.data
        if let user = Auth.auth().currentUser {
            speed.uid = user.uid
        }
    }
    
    // MARK: Public
    
    func timeFormatted(_ field: Int) -> String {
        let totalSeconds = speedTimes.data[field]
        let seconds: Int = totalSeconds! % 60
        let minutes: Int = (totalSeconds! / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func prepareGraphData() {
        speed.graphData.map {
            $0 / 10
        }
        print("BEFORE: \(speed.graphData.count)")
        var data = [Double]()

        for index in stride(from: 0, through: speed.graphData.count, by: 2) {
            if index > 0 && index < speed.graphData.count {
                data.append((self.speed.graphData[index] + self.speed.graphData[index - 1]) / 2)
            }
        }
        speed.graphData = data
        print("AFTER: \(speed.graphData.count)")
    }
}
