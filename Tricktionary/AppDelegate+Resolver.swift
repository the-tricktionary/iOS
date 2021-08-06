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
            TrickListUseCase(trickListRepository: TrickListRepository())
        }
        
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
        
        register {
            TricksContentManager()
        }
        .implements(TricksContentManagerType.self)
        .scope(.shared)
        
        register {
            Settings()
        }
        .implements(TricksListSettingsType.self)
        .implements(SettingsViewModelType.self)
        
        Self.registerViewModels()
    }
    
    private static func registerViewModels() {
        register {
            TricksViewModel()
        }
        
        register {
            SpeedDataViewModel(speedDataRepository: SpeedManager.shared)
        }
        
        register {
            MenuViewModel()
        }
        
        register { resolver, _ in
            TrickDetailViewModel(dataProvider: resolver.resolve(TrickDetailDataProviderType.self, name: nil, args: nil),
                                 settings: Settings(),
                                 tricksManager: resolver.resolve(TricksContentManager.self, name: nil, args: nil))
        }
        .implements(TrickDetailViewModelType.self)
        
        register {
            SettingsViewModel()
        }
    }
    
}

extension Resolver.Name {
    static let localDataSource = Self("local")
    static let remoteDataSource = Self("remote")
}

protocol DataSourceType {
    func legitimize()
}

class LocalDataSource: DataSourceType {
    func legitimize() {
        print("Hello I'm local data source")
    }
}
class RemoteDataSource: DataSourceType {
    func legitimize() {
        print("Hello I'm remote data source")
    }
}

class DataProvider: Resolving {
    
    private let local: Bool
    
    private lazy var dataSource: DataSourceType? = resolver.optional(DataSourceType.self, name: local ? .localDataSource : .remoteDataSource)
    
    init(local: Bool) {
        self.local = local
    }
    
    func sayHello() {
        dataSource?.legitimize()
    }
}
