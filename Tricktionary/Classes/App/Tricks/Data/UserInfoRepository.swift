//
//  UserInfoRepository.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 30.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine

struct UserInfoRepository: UserInfoProviding {
    func getChecklist() -> AnyPublisher<[String], Error> {
        return CurrentValueSubject<[String], Error>(
            []
        ).eraseToAnyPublisher()
    }
}
