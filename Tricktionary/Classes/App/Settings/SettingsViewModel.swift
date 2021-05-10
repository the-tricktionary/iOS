//
//  SettingsViewModel.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 04/02/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine

protocol SettingsViewModelType {
    var auto: Bool { get set }
    var fullscreen: Bool { get set }
    var showIjru: Bool { get set }
    var showIrsf: Bool { get set } // deprecated
    var showWjr: Bool { get set } // deprecated
    
    
    var ijru: Bool { get set }
    var irsf: Bool { get set }
    var wjr: Bool { get set }
    
    var autoFullscreen: Bool { get set }
    var autoplay: Bool { get set }
}

class SettingsViewModel: SettingsViewModelType, ObservableObject {
    
    // MARK: - Variables
    
    @Published var ijru: Bool = false
    @Published var irsf: Bool = false
    @Published var wjr: Bool = false
    
    @Published var autoFullscreen: Bool = false
    @Published var autoplay: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        autoplay = auto
        autoFullscreen = autoplay
        
        ijru = showIjru
        
        bind()
    }
    
    // Persistent
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
    
    private func bind() {
        $ijru.sink { value in
            self.showIjru = value
        }.store(in: &cancellable)
        
        $autoplay.sink { value in
            self.auto = value
        }.store(in: &cancellable)
        
        $autoFullscreen.sink { value in
            self.fullscreen = value
        }.store(in: &cancellable)
    }
    
}
