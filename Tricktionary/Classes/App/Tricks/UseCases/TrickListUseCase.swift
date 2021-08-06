//
//  TrickListUseCase.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 29.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine

protocol TrickDataProviding {
    func getTrickList(discipline: String) -> AnyPublisher<[BaseTrick], Error>
}

class TrickListUseCase {

    // MARK: - Variables
    // private
    private let trickListRepository: TrickDataProviding

    // MARK: - Initializer
    init(trickListRepository: TrickDataProviding) {
        self.trickListRepository = trickListRepository
    }

    func loadTricks(discipline: String) -> AnyPublisher<[BaseTrick], Error> {
        trickListRepository.getTrickList(discipline: discipline)
    }
}
