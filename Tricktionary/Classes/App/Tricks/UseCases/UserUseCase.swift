//
//  UserUseCase.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 29.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//
import Foundation
import Combine

protocol UserInfoProviding {
    func getChecklist() -> AnyPublisher<[String], Error>
}

class UserUseCase {
    // MARK: - Variables
    private let userInfoRepository: UserInfoProviding

    // MARK: - Initializer
    init(
        userInfoRepository: UserInfoProviding
    ) {
        self.userInfoRepository = userInfoRepository
    }

    func getUserCheckList() -> AnyPublisher<[String], Error> {
        userInfoRepository.getChecklist().eraseToAnyPublisher()
    }
}
