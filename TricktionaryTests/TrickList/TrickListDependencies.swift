//
//  TrickListDependencies.swift
//  TricktionaryTests
//
//  Created by Marek Štovíček on 02.03.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine

class UserManagerTest: UserManagerType {
    var userStateDidChange = PassthroughSubject<Bool, Never>()
    var userName: String? = "Marek"
    var userId: String? = "id0001"
    var logged: Bool = false
    
    var email: String? = nil
    var imageData: Data? = nil
    func logout() {}
}

class DataProviderTest: TricksDataProviderType {
    let publisher = PassthroughSubject<Trick, Error>()
    func getTricks(discipline: Disciplines) -> AnyPublisher<[BaseTrick], Error> {
        Fail(error: NSError(domain: "",
                            code: 0,
                            userInfo: nil)).eraseToAnyPublisher()
    }
    func getChecklist() -> AnyPublisher<[String], Error> {
        Fail(error: NSError(domain: "",
                            code: 0,
                            userInfo: nil)).eraseToAnyPublisher()
    }
}

class RemoteConfigTest: RemoteConfigType {
    var disciplines: [Disciplines] = []
    var isSwiftUIEnabled: Bool = true
    func fetchRemoteConfig() {}
}

class TrickListSettingTest: TricksListSettingsType {
    var showIjru: Bool = true
    var showIrsf: Bool = false
    var showWjr: Bool = false
}

class TricksContentManagerTest: TricksContentManagerType {
    var completedTricks: [String] = []
}

class TricksContentManagerTestNotEmpty: TricksContentManagerType {
    var completedTricks: [String] = ["ahoj", "hello"]
}
