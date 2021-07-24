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
import FirebaseAuth

class SpeedDataViewModel: ObservableObject {
    enum State {
        case loading
        case notLogged
        case loaded(data: [Speed])
    }
    // MARK: Variables
    
    @Published var speeds: [Speed] = []
    @Published var state: State = .loading

    private let speedDataRepository: SpeedManager

    // MARK: Public
    init(speedDataRepository: SpeedManager) {
        self.speedDataRepository = speedDataRepository
    }
    
    func getSpeedData(starting: @escaping () -> Void, finish: @escaping () -> Void) {
        guard Auth.auth().currentUser != nil else {
            state = .notLogged
            return
        }
        var data: [Speed] = []
        speedDataRepository.getSpeedData(starting: {
            self.state = .loading
            starting()
        }, completion: { (speed) in
            data.append(speed)
            self.speeds.append(speed)
        }) {
            self.speeds = data
            self.state = .loaded(data: data)
            finish()
        }
    }
}
