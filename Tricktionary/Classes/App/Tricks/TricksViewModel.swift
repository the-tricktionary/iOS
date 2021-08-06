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
import FirebaseAuth
import Combine
import Resolver

enum TrickListState {
    case loading
    case error(String)
    case fetched([TableSection])
}

class TricksViewModel: ObservableObject {
    // MARK: - Variables
    // DI
    @Injected var tricksManager: TricksContentManagerType
    @Injected var dataProvider: TricksDataProviderType
    @Injected var remoteConfig: RemoteConfigType
    @Injected var userManager: UserManagerType
    @Injected var settings: TricksListSettingsType
    @Injected var trickListUseCase: TrickListUseCase
    
    // published
    @Published var uiTricks: [BaseTrick] = []
    @Published var uiSections: [TableSection] = []
    @Published var searchText: String = ""

    @Published var state: TrickListState = .loading

    let level = CurrentValueSubject<Int, Never>(1)
    let discipline = CurrentValueSubject<Int, Never>(0)

    // private
    private var cancelable = Set<AnyCancellable>()
    private var allTricksId: [String : String] = [String : String]()
    private let tricks = CurrentValueSubject<[BaseTrick], Never>([])
    
    // public
    let sections = CurrentValueSubject<[TableSection], Never>([])
    var loading = CurrentValueSubject<Bool, Never>(true)

    var isPullToRefresh: Bool = false
    
    var username: String? {
        userManager.userName
    }

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
        getLevels()
    }

    var disciplines: [Disciplines] {
        remoteConfig.disciplines
    }

    // MARK: - Initializer
    
    init() {
        bind()
    }
    
    // MARK: - Publics
    
    func getTricks(silent: Bool = false) {
        if silent {
            makeContent()
            return
        }
        state = .loading
        tricks.value.removeAll()
        trickListUseCase.loadTricks(discipline: "")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                default:
                    break
                }
            } receiveValue: { trickList in
                self.tricks.value.append(contentsOf: trickList)
                self.uiTricks = trickList
                self.allTricksId = trickList.reduce(into: [String: String]()) {
                    $0[$1.name] = $1.id
                }
                self.loading.send(false)
                self.selectMinLevel()
            }.store(in: &cancelable)
    }

    func toggleSection(name: String) {
        for (index, section) in sections.value.enumerated() {
            if section.name == name {
                if section.collapsed {
                    let tricksForLevel = self.tricks.value.filter { $0.level == selectedLevel }
                    self.sections.value[index].rows = tricksForLevel.filter { $0.type == name }
                        .map { TrickLevelCell.Content(id: $0.name,
                                                      title: $0.name,
                                                      levels: makeLevels(trick: $0),
                                                      isDone: self.isDone($0)) }
                    self.sections.value[index].collapsed = false
                    self.sections.value[index].tricks = self.sections.value[index].rows.count
                    self.sections.value[index].completed = self.userManager.logged ? self.sections.value[index].rows.filter{$0.isDone}.count : nil
                } else {
                    self.sections.value[index].rows.removeAll()
                    self.sections.value[index].collapsed = true
                }
            }
        }
        uiSections = sections.value
    }

    func getFilteredTricks(substring: String) -> [BaseTrick]? {
        return tricks.value.filter { $0.name.lowercased().contains(substring.lowercased()) }
    }
    
    func done(trickName: String) -> Bool {
        guard let trickId = tricks.value.filter({ $0.name == trickName }).first?.id else {
            return false
        }
        return tricksManager.completedTricks.contains(trickId)
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
        
        sections.value = types.reduce([TableSection]()) { (result: [TableSection], type: String) -> [TableSection] in
            let rows = tricksForLevel
                .filter { $0.type == type }
                .map {
                    TrickLevelCell.Content(id: $0.name,
                                           title: $0.name,
                                           levels: makeLevels(trick: $0),
                                           isDone: isDone($0))
                }
            return result + [TableSection(id: type,
                                          name: type,
                                          rows: rows,
                                          collapsed: false,
                                          tricks: rows.count,
                                          completed: self.userManager.logged ? rows.filter { $0.isDone }.count : nil)]
        }
        uiSections = sections.value
        state = .fetched(sections.value)
    }
    
    private func makeFilteredContent(tricks: [BaseTrick]?) {
        uiSections = [TableSection(id: "search",
                                   name: "Searched",
                                   rows: tricks?.map {
                                    TrickLevelCell.Content(id: $0.name, title: $0.name, levels: self.makeLevels(trick: $0), isDone: isDone($0))
                                   } ?? [],
                                   collapsed: false,
                                   tricks: tricks?.count ?? 0)]
    }
    
    private func bind() {
        $searchText.sink { substring in
            guard substring.isEmpty == false else {
                self.makeContent()
                return
            }
            let filtered = self.getFilteredTricks(substring: substring)
            self.makeFilteredContent(tricks: filtered)
        }.store(in: &cancelable)

        level.combineLatest(discipline)
            .sink { (level, discipline) in
                print("### discipline \(discipline) level \(level)")
            }
            .store(in: &cancelable)
    }

    // MARK: - Helpers

    private func isDone(_ trick: BaseTrick) -> Bool {
        return tricksManager.completedTricks.contains(allTricksId[trick.name] ?? "") && userManager.logged
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
        selectedLevel = levels.min() ?? 1
    }
}
