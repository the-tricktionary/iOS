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
    var collapsed: Bool
}

protocol TricksViewModelType {
    var sections: MutableProperty<[TableSection]> { get }
    var selectedLevel: Int { get set }
    var levels: [Int] { get }
    var disciplines: [Disciplines] { get }
    var selectedDiscipline: Int { get set }
    func toggleSection(name: String)
}

class TricksViewModel: TricksViewModelType {
    
    // MARK: Variables
    let sections = MutableProperty<[TableSection]>([TableSection]())
    private let tricks: MutableProperty<[BaseTrick]> = MutableProperty<[BaseTrick]>([BaseTrick]())

    var selectedLevel: Int = 1 {
        didSet {
            sections.value.removeAll()
            if selectedLevel > levels.max() ?? 0 {
                selectedLevel = levels[0] // FAIL
            }
            self.makeContent()
        }
    }
    var selectedDiscipline = 0 {
        didSet {
            sections.value.removeAll()
            if self.selectedDiscipline > self.disciplines.count - 1 {
                self.selectedDiscipline = 0
            }
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
            print("LOADED \(self?.tricks.value.count)")
            self?.selectMinLevel()
            self?.onFinishLoading?()
        }
    }

    func toggleSection(name: String) {
        for (index, section) in sections.value.enumerated() {
            if section.name == name {
                if section.collapsed {
                    let tricksForLevel = self.tricks.value.filter { $0.level == selectedLevel }
                    self.sections.value[index].rows = tricksForLevel.filter { $0.type == name }
                    self.sections.value[index].collapsed = false
                } else {
                    self.sections.value[index].rows.removeAll()
                    self.sections.value[index].collapsed = true
                }
            }
        }
    }

    private func selectMinLevel() {
        let levels = tricks.value.map { trick -> Int in
            return trick.level
        }
        if let min = levels.min() {
            selectedLevel = min
        } else {
            selectedLevel = 1
        }
    }

    private func getTypes(levelTricks: [BaseTrick]) -> [String] {
        var types = Set<String>()
        levelTricks.forEach { types.insert($0.type) }

        return Array(types).sorted(by: { (trick1, trick2) -> Bool in
            trick1 < trick2
        })
    }

    private func makeContent() {
        let tricksForLevel = tricks.value.filter { $0.level == selectedLevel }
        let types = getTypes(levelTricks: tricksForLevel)
        types.forEach { type in
            sections.value.append(TableSection(name: type, rows: tricksForLevel.filter { $0.type == type }, collapsed: false))
        }
    }
}
