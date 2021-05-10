//
//  TrickListResolver.swift
//  TricktionaryTests
//
//  Created by Marek Štovíček on 02.03.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Resolver

extension Resolver {
    static func registerTrickListDependencies() {
        register {
            UserManagerTest()
        }.implements(UserManagerType.self)
        
        register {
            DataProviderTest()
        }.implements(TricksDataProviderType.self)
        
        register {
            RemoteConfigTest()
        }.implements(RemoteConfigType.self)
        
        register {
            TrickListSettingTest()
        }.implements(TricksListSettingsType.self)
        
        register {
            TricksContentManagerTest()
        }.implements(TricksContentManagerType.self)
    }
}
