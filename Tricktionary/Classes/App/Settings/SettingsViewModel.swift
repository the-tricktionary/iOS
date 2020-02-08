//
//  SettingsViewModel.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 04/02/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation

protocol SettingsViewModelType {
    var auto: Bool { get set }
    var fullscreen: Bool { get set }
    var showIjru: Bool { get set }
    var showIrsf: Bool { get set }
    var showWjr: Bool { get set }
}

class SettingsViewModel: SettingsViewModelType {
    @Persistent(key: PxSettings.autoplay, defaultValue: false)
    var auto: Bool

    @Persistent(key: PxSettings.fullscreen, defaultValue: false)
    var fullscreen: Bool

    @Persistent(key: PxSettings.ijruLevels, defaultValue: false)
    var showIjru: Bool

    @Persistent(key: PxSettings.irsfLevels, defaultValue: false)
    var showIrsf: Bool

    @Persistent(key: PxSettings.wjrLevels, defaultValue: false)
    var showWjr: Bool
}
