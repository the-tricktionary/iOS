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

struct TableSection {
    var name: String
    var rows: [BaseTrick]
}

protocol TricksViewModelType {
    var sections: MutableProperty<[TableSection]> { get }
    var selectedLevel: Int { get set }
    var levels: [Int] { get }
    var disciplines: [Disciplines] { get }
    var selectedDiscipline: Int { get set }
}

class TricksViewModel: TricksViewModelType {
    
    // MARK: Variables
    let sections = MutableProperty<[TableSection]>([TableSection]())
    private let tricks: MutableProperty<[BaseTrick]> = MutableProperty<[BaseTrick]>([BaseTrick]())

    var selectedLevel: Int = 1 {
        didSet {
            sections.value.removeAll()
            if selectedLevel > levels.count {
                selectedLevel = 1
            }
            self.makeContent(for: selectedLevel)
        }
    }
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
        tricks.value.removeAll()
        dataProvider.getTricks(discipline: disciplines[selectedDiscipline], starting: { [weak self] in
            self?.onStartLoading?()
        }, completion: { [weak self] (data) in
            self?.tricks.value.append(data)
        }) { [weak self] in
            self?.makeContent(for: self?.selectedLevel ?? 1)
            self?.onFinishLoading?()
        }
    }

    private func getTypes(levelTricks: [BaseTrick]) -> [String] {
        var types = Set<String>()
        levelTricks.forEach { types.insert($0.type) }

        return Array(types).sorted(by: { (trick1, trick2) -> Bool in
            trick1 < trick2
        })
    }

    private func makeContent(for level: Int) {
        let tricksForLevel = tricks.value.filter { $0.level == level }
        let types = getTypes(levelTricks: tricksForLevel)
        types.forEach { type in
            sections.value.append(TableSection(name: type, rows: tricksForLevel.filter { $0.type == type }))
        }
    }
}
