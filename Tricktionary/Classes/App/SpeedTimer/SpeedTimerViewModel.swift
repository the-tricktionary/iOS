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
import Combine

protocol SpeedTimerVMType {
    var sections: PassthroughSubject<[SpeedTableSection], Never> { get }
    func loadEvents()
}

class SpeedTimerViewModel: SpeedTimerVMType {

    var sections = PassthroughSubject<[SpeedTableSection], Never>()
    
    // MARK: Variables
    private let dataProvider: SpeedTimerDataProviderType
    private var cancelable = Set<AnyCancellable>()
    
    // MARK: Public

    // MARK: - Initializer
    init(dataProvider: SpeedTimerDataProviderType) {
        self.dataProvider = dataProvider
    }

    func loadEvents() {
        dataProvider.fetchEvents().sink { (completion) in
            //
        } receiveValue: { (events) in
            var allEvents = [SpeedEvent(name: "Only clicker", periods: 0, checkpoints: 0)]
            allEvents.append(contentsOf: events)
            let section = SpeedTableSection(rows: allEvents)
            self.sections.send([section])
        }.store(in: &cancelable)
    }
    
//    func timeFormatted(_ field: Int) -> String {
//        let totalSeconds = speedTimes.data[field]
//        let seconds: Int = totalSeconds! % 60
//        let minutes: Int = (totalSeconds! / 60) % 60
//             let hours: Int = totalSeconds / 3600
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
    
//    func prepareGraphData() {
//        speed.graphData.map {
//            $0 / 10
//        }
//        var data = [Double]()
//
//        for index in stride(from: 0, through: speed.graphData.count, by: 2) {
//            if index > 0 && index < speed.graphData.count {
//                data.append((self.speed.graphData[index] + self.speed.graphData[index - 1]) / 2)
//            }
//        }
//        speed.graphData = data
//    }
}
