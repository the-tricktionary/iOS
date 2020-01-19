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
import FirebaseAuth

struct TableSection {
    var name: String
    var rows: [TrickLevelCell.Content]
    var collapsed: Bool
    var tricks: Int
    var completed: Int?
}

protocol TricksListSettingsType {
    var showIjru: Bool { get }
    var showIrsf: Bool { get }
    var showWjr: Bool { get }
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
    func getFilteredTricks(substring: String) -> [BaseTrick]?
    var settings: TricksListSettingsType { get }
    var isLogged: Bool { get }
}

class TricksViewModel: TricksViewModelType {

    // MARK: Variables
    private let checkList = MutableProperty<[String]>([String]())
    private var allTricksId: [String : String] = [String : String]()
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

    var isLogged: Bool {
        return auth.currentUser != nil
    }
    
    var onStartLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    
    private let dataProvider: TricksDataProviderType
    private let remoteConfig: RemoteConfig
    private let auth: Auth
    var settings: TricksListSettingsType
    
    // MARK: Initializer
    
    init(dataProvider: TricksDataProviderType,
         remoteConfig: RemoteConfig,
         settings: TricksListSettingsType, auth: Auth) {
        self.dataProvider = dataProvider
        self.remoteConfig = remoteConfig
        self.settings = settings
        self.auth = auth
    }
    
    // MARK: Publics
    
    func getTricks(silent: Bool = false) {
        if silent {
            sections.value.removeAll()
            makeContent()
            return
        }
        func getTrickList() {
            tricks.value.removeAll()
            dataProvider.getTricks(discipline: disciplines[selectedDiscipline], starting: { [weak self] in
                self?.onStartLoading?()
            }, completion: { [weak self] (data, id) in
                self?.tricks.value.append(data)
                self?.allTricksId[data.name] = id
            }) { [weak self] in
                print("Loaded: \(self?.tricks.value.count)")
                self?.selectMinLevel()
                self?.onFinishLoading?()
            }
        }
        dataProvider.getChecklist(starting: {
            //
        }, completion: { list in
            self.checkList.value = list ?? []
        }) {
            getTrickList()
        }
    }

    func toggleSection(name: String) {
        for (index, section) in sections.value.enumerated() {
            if section.name == name {
                if section.collapsed {
                    let tricksForLevel = self.tricks.value.filter { $0.level == selectedLevel }
                    self.sections.value[index].rows = tricksForLevel.filter { $0.type == name }
                        .map { TrickLevelCell.Content(title: $0.name,
                                                      levels: makeLevels(trick: $0),
                                                      isDone: self.isDone($0)) }
                    self.sections.value[index].collapsed = false
                    self.sections.value[index].tricks = self.sections.value[index].rows.count
                    self.sections.value[index].completed = isLogged ? self.sections.value[index].rows.filter{$0.isDone}.count : nil
                } else {
                    self.sections.value[index].rows.removeAll()
                    self.sections.value[index].collapsed = true
                }
            }
        }
    }

    func getFilteredTricks(substring: String) -> [BaseTrick]? {
        return tricks.value.filter { $0.name.lowercased().contains(substring.lowercased()) }
    }

    // MARK: - Privates

    private func makeLevels(trick: BaseTrick) -> [Organization : String?] {
        var levels = [Organization : String]()
        if settings.showIjru {
            levels[.ijru] = trick.levels?.ijru.level
        }
        if settings.showIrsf {
            levels[.irsf] = trick.levels?.irsf.level
        }
        if settings.showWjr {
            levels[.wjr] = trick.levels?.wjr.level
        }
        return levels
    }

    private func makeContent() {
        let tricksForLevel = tricks.value.filter { $0.level == selectedLevel }
        let types = getTypes(levelTricks: tricksForLevel)
        print("COMPLETED TRICKS")
        checkList.value.forEach { (completed) in
            print("COMPLETED: \(completed)")
        }
        types.forEach { type in
            let _rows = tricksForLevel.filter { $0.type == type }
                .map { TrickLevelCell.Content(title: $0.name,
                                              levels: makeLevels(trick: $0),
                                              isDone: self.isDone($0)) }
            sections.value.append(TableSection(name: type,
                                               rows: _rows,
                                               collapsed: false,
                                               tricks: _rows.count,
                                               completed: isLogged ? _rows.filter{$0.isDone}.count : nil))
        }
    }

    // Helpers

    private func isDone(_ trick: BaseTrick) -> Bool {
        return checkList.value.contains(allTricksId[trick.name] ?? "") && auth.currentUser != nil
    }

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
