//
//  RemoteConfig.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 20/11/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigType {
    var disciplines: [Disciplines] { get }
    var isSwiftUIEnabled: Bool { get }
    func fetchRemoteConfig()
}

class TRRemoteConfig: RemoteConfigType {
    
    // MARK: - Variables
    // private
    private var remoteConfig: RemoteConfig {
        let config = RemoteConfig.remoteConfig()
        config.configSettings = RemoteConfigSettings()
        return config
    }
    
    // public
    var disciplines: [Disciplines] {
        self.getDisciplines()
    }
    
    var isSwiftUIEnabled: Bool {
        remoteConfig.configValue(forKey: "ios_swiftUI").boolValue
    }
    
    // MARK: - Publics
    func fetchRemoteConfig() {
        remoteConfig.configSettings = RemoteConfigSettings()

        remoteConfig.setDefaults([
            "singlerope": true as NSObject,
            "wheels": false as NSObject,
            "doubledutch": false as NSObject
        ])

        remoteConfig.fetch(withExpirationDuration: 0) { (status, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if status == .success {
                self.remoteConfig.activate { (_, error) in
                    if let error = error {
                        print("Error while activating fetched config \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: - Privates
    
    private func getDisciplines() -> [Disciplines] {
        var allowedDisciplines: [Disciplines] = []
        if remoteConfig.configValue(forKey: "singlerope").boolValue {
            allowedDisciplines.append(.singleRope)
        }
        if remoteConfig.configValue(forKey: "wheels").boolValue {
            allowedDisciplines.append(.wheels)
        }
        if remoteConfig.configValue(forKey: "doubledutch").boolValue {
            allowedDisciplines.append(.doubleDutch)
        }
        return allowedDisciplines
    }
}
