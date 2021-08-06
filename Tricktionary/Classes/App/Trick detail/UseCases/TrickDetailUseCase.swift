//
//  TrickDetailUseCase.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 31.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine

protocol TrickDetailProviding {
    func getTrickDetail(with id: String) -> AnyPublisher<Trick, Error>
}

class TrickDetailUseCase {

    // MARK: - Variables
    private let trickDetailRepository: TrickDetailProviding

    init(trickDetailRepository: TrickDetailProviding) {
        self.trickDetailRepository = trickDetailRepository
    }

    func getTrickDetail(with id: String) -> AnyPublisher<Trick, Error> {
        trickDetailRepository.getTrickDetail(with: id)
    }
}
