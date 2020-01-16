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
    var rows: [TrickLevelCell.Content]
    var collapsed: Bool
}

protocol TricksListSettingsType {
    var showLevels: Bool { get set }
}

protocol TricksViewModelType {
    var onStartLoading: (() -> Void)? { get set }
    var onFinishLoading: (() -> Void)? { get set }
    var sections: MutableProperty<[TableSection]> { get }
    var selectedLevel: Int { get set }
    var levels: [Int] { get }
    var disciplines: [Disciplines] { get }
    var selectedDiscipline: Int { get set }
    func toggleSection(name: String)
    var settings: TricksListSettingsType { get }
}

class TricksViewModel: TricksViewModelType {
    
    // MARK: Variables
    let sections = MutableProperty<[TableSection]>([TableSection]())
    private let tricks: MutableProperty<[BaseTrick]> = MutableProperty<[BaseTrick]>([BaseTrick]())

    var selectedLevel: Int = 1 {
        didSet {
            sections.value.removeAll()
            if !levels.contains(selectedLevel) {
                selectedLevel = levels.min() ?? 1
            }
            makeContent()
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
        return getLevels()
    }

    var disciplines: [Disciplines] {
        return getAllowedDisciplines()
    }
    
    var onStartLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    
    private let dataProvider: TricksDataProviderType
    private let remoteConfig: RemoteConfig
    var settings: TricksListSettingsType
    
    // MARK: Initializer
    
    init(dataProvider: TricksDataProviderType, remoteConfig: RemoteConfig, settings: TricksListSettingsType) {
        self.dataProvider = dataProvider
        self.remoteConfig = remoteConfig
        self.settings = settings
    }
    
    // MARK: Publics
    
    func getTricks(silent: Bool = false) {
        if silent {
            sections.value.removeAll()
            makeContent()
            return
        }
        tricks.value.removeAll()
        dataProvider.getTricks(discipline: disciplines[selectedDiscipline], starting: { [weak self] in
            self?.onStartLoading?()
        }, completion: { [weak self] (data) in
            self?.tricks.value.append(data)
        }) { [weak self] in
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
                        .map { TrickLevelCell.Content(title: $0.name,
                                                      description: self.settings.showLevels ? $0.levels?.ijru.level : nil,
                                                      isDone: false) }
                    self.sections.value[index].collapsed = false
                } else {
                    self.sections.value[index].rows.removeAll()
                    self.sections.value[index].collapsed = true
                }
            }
        }
    }

    // MARK: - Privates

    private func makeContent() {
        let tricksForLevel = tricks.value.filter { $0.level == selectedLevel }
        let types = getTypes(levelTricks: tricksForLevel)
        types.forEach { type in
            let rows = tricksForLevel.filter { $0.type == type }
                .map { TrickLevelCell.Content(title: $0.name,
                                              description: self.settings.showLevels ? $0.levels?.ijru.level : nil,
                                              isDone: false) }
            sections.value.append(TableSection(name: type, rows: rows, collapsed: false))
        }
    }

    // Helpers

    private func getAllowedDisciplines() -> [Disciplines] {
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

    private func getLevels() -> [Int] {
        var uniqueLevels: [Int] = []
        self.tricks.value.forEach { trick in
            if !uniqueLevels.contains(trick.level) {
                uniqueLevels.append(trick.level)
            }
        }

        return uniqueLevels.sorted { $0 < $1 }
    }

    private func getTypes(levelTricks: [BaseTrick]) -> [String] {
        var types = Set<String>()
        levelTricks.forEach { types.insert($0.type) }

        return Array(types).sorted(by: { (trick1, trick2) -> Bool in
            trick1 < trick2
        })
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
}
