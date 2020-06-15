//
//  ViewControllerFactory.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 23/05/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseRemoteConfig

class ViewControllerFactory {
    private static let authentication = Auth.auth()
    private static let remoteConfig = RemoteConfig.remoteConfig()

    static func makeTrickListVC() -> TricksViewController {
        let vm = TricksViewModel(dataProvider: TrickManager.shared,
                                 remoteConfig: Self.remoteConfig,
                                 settings: Settings(),
                                 auth: Self.authentication)
        let vc = TricksViewController(viewModel: vm)
        return vc
    }
}
