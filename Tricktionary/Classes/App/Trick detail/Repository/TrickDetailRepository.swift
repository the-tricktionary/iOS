//
//  TrickDetailRepository.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 31.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine

struct TrickDetailRepository: TrickDetailProviding {
    func getTrickDetail(with id: String) -> AnyPublisher<Trick, Error> {
        let publisher = PassthroughSubject<Trick, Error>()

        Network.shared.apollo.fetch(query: TrickDetailQuery(trickId: id)) { result in
            switch result {
            case let .success(data):
                let gqlTrick = data.data?.trick
                let trick = Trick(id: nil,
                                  name: gqlTrick?.localisation?.name ?? "No name",
                                  videos: Video(youtube: gqlTrick?.videos.first?.videoId ?? ""),
                                  description: gqlTrick?.localisation?.description ?? "",
                                  levels: Levels(["ijru": gqlTrick?.levels.first { $0.organisation == "ijru" }?.level ?? "-"]),
                                  prerequisites: nil)
                publisher.send(trick)
            case let .failure(error):
                publisher.send(completion: .failure(error))
            }
        }

        return publisher.eraseToAnyPublisher()
    }
}
