//
//  ViewControllerFactory.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 23/05/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import Swinject

class ViewControllerFactory {
    private static var resolver: Resolver {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let resolver = delegate.resolver else {
            fatalError("Not resolver found")
        }
        return resolver
    }

    static func makeTrickListVC() -> TricksViewController {
        let vm = TricksViewModel(dataProvider: Self.resolver.resolve(TricksDataProviderType.self)!,
                                 remoteConfig: Self.resolver.resolve(RemoteConfigType.self)!,
                                 settings: Settings(),
                                 userManager: Self.resolver.resolve(UserManagerType.self)!,
                                 tricksManager: Self.resolver.resolve(TricksContentManager.self)!)
        let vc = TricksViewController(viewModel: vm)
        return vc
    }
    
    static func makeTrickDetailVC(trick: String, done: Bool) -> TrickDetailViewController {
        let vm = TrickDetailViewModel(trick: trick,
                                      dataProvider: Self.resolver.resolve(TrickDetailDataProviderType.self)!,
                                      settings: Settings(),
                                      done: done,
                                      tricksManager: Self.resolver.resolve(TricksContentManager.self)!)
        let vc = TrickDetailViewController(viewModel: vm)
        return vc
    }
    
    static func makeProfileVC() -> ProfileViewController {
        let vm = ProfileViewModel(trickManager: Self.resolver.resolve(TricksContentManager.self)!)
        let vc = ProfileViewController(viewModel: vm)
        return vc
    }
}
