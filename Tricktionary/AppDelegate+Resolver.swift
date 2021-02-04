//
//  AppDelegate+Resolver.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 03/02/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {    
    public static func registerDependencies() {
        register {
            UserManager()
        }
        .implements(UserManagerType.self)
        
        register {
            TrickManager.shared
        }
        .implements(TricksDataProviderType.self)
        
        register {
            TRRemoteConfig()
        }
        .implements(RemoteConfigType.self)
        
        register {
            TrickManager.shared
        }
        .implements(ChecklistDataProviderType.self)
        
        register {
            TrickManager.shared
        }
        .implements(TrickDetailDataProviderType.self)
        
        register { resolver, _ in
            TricksContentManager(userManager: resolver.resolve(UserManagerType.self, name: nil, args: nil),
                                 checklistDataProvider: resolver.resolve(ChecklistDataProviderType.self, name: nil, args: nil))
        }.scope(.shared)
        
        Self.registerViewModels()
    }
    
    private static func registerViewModels() {
        register { resolver, _ in
            TricksViewModel(dataProvider: resolver.resolve(TricksDataProviderType.self, name: nil, args: nil),
                            remoteConfig: resolver.resolve(RemoteConfigType.self, name: nil, args: nil),
                            settings: Settings(),
                            userManager: resolver.resolve(UserManagerType.self, name: nil, args: nil),
                            tricksManager: resolver.resolve(TricksContentManager.self, name: nil, args: nil))
        }
        .implements(TricksViewModelType.self)
        
        register { resolver, _ in
            TrickDetailViewModel(dataProvider: resolver.resolve(TrickDetailDataProviderType.self, name: nil, args: nil),
                                 settings: Settings(),
                                 tricksManager: resolver.resolve(TricksContentManager.self, name: nil, args: nil))
        }
        .implements(TrickDetailViewModelType.self)
    }
    
}
