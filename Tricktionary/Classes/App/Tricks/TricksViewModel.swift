//
//  TricksViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseRemoteConfig
import ReactiveSwift

protocol TricksViewModelType {
    var tricks: MutableProperty<[Trick]> { get }
    var filteredTricks: [Trick] { get }
    var selectedLevel: Int { get set }
    var levels: [Int] { get }
    var disciplines: [Disciplines] { get }
    var selectedDiscipline: Int { get set }
    
    func getTricks()
}

class TricksViewModel: TricksViewModelType {
    
    // MARK: Variables
    var tricks: MutableProperty<[Trick]> = MutableProperty<[Trick]>([Trick]())
    var filteredTricks: [Trick] = [Trick]()
    
    var selectedLevel: Int = 1
    var selectedDiscipline = 0 {
        didSet {
            self.getTricks()
        }
    }

    var levels: [Int] {
        var uniqueLevels: [Int] = []
        self.tricks.value.forEach { trick in
            if !uniqueLevels.contains(trick.level) {
                uniqueLevels.append(trick.level)
            }
        }

        return uniqueLevels.sorted { $0 < $1 }
    }

    var disciplines: [Disciplines] {
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
    
    var onStartLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    
    private let dataProvider: TricksDataProviderType
    private let remoteConfig: RemoteConfig
    
    // MARK: Initializer
    
    init(dataProvider: TricksDataProviderType, remoteConfig: RemoteConfig) {
        self.dataProvider = dataProvider
        self.remoteConfig = remoteConfig
    }
    
    // MARK: Publics
    
    func getTricks() {
        print("Loading tricks from \(selectedDiscipline) discipline")
        tricks.value.removeAll()
        dataProvider.getTricks(discipline: disciplines[selectedDiscipline], starting: { [weak self] in
            self?.onStartLoading?()
        }, completion: { [weak self] (data) in
            if self?.selectedDiscipline == 2 {
                print("Trick: \(data.name)")
            }
            self?.tricks.value.append(data)
        }) { [weak self] in
            print("Loaded tricks: \(self?.tricks.value.count)")
            self?.onFinishLoading?()
        }
    }

    func getTrickTypes() -> [String] {
        let levelTricks = tricks.value.filter { $0.level == self.selectedLevel }
        var types = Set<String>()
        levelTricks.forEach { (trick) in
            types.insert(trick.type)
        }

        return Array(types).sorted(by: { (trick1, trick2) -> Bool in
            trick1 < trick2
        })
    }
    
    func getTricks(_ type: String) -> [Trick] {
        return tricks.value.filter {
            $0.level == self.selectedLevel && $0.type == type
        }
    }
}
