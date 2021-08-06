//
//  TrickListRepository.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 29.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine
import Apollo

struct TrickListRepository: TrickDataProviding {
    func getTrickList(discipline: String) -> AnyPublisher<[BaseTrick], Error> {
        // TODO: Implement discipline switcher
        let publisher = PassthroughSubject<[BaseTrick], Error>()
        var tricks: [BaseTrick]?
        Network.shared.apollo.fetch(query: TrickListQuery(tricksDiscipline: .singleRope)) { result in
            switch result {
            case let .success(data):
                tricks = data.data?.tricks.compactMap { trick in
                    let tricktionaryLevel = trick.levels.first { $0.organisation == "tricktionary" }?.level ?? "0"
                    let levels = trick.levels.reduce(into: [String: Any]()) { result, level in
                        if level.organisation != "tricktionary" {
                            result[level.organisation] = level.level
                        }
                    }
                    print(trick.id)
                    return BaseTrick(name: trick.localisation?.name ?? "-",
                                     level: Int(tricktionaryLevel) ?? 0,
                                     type: trick.trickType.rawValue,
                                     levels: Levels(levels),
                                     id: trick.id)
                }
                publisher.send(tricks ?? [])
            case let .failure(error):
                publisher.send(completion: .failure(error))
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
