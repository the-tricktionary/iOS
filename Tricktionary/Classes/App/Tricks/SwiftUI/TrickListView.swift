//
//  TrickListView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 22/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import SwiftUI

struct TrickListView: View {
    @ObservedObject var vm = TricksViewModel(dataProvider: TrickManager.shared,
                             remoteConfig: TRRemoteConfig(),
                             settings: Settings(),
                             userManager: UserManager(),
                             tricksManager: TricksContentManager(userManager: UserManager(),
                                                                 checklistDataProvider: TrickManager.shared))
    
    @State var pickerPresented = false
    @State private var picker: Picker = .levels
    
    init() {
        vm.getTricks()
    }
        
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.uiSections) { section in
                    let header = LevelHeaderView(title: section.name,
                                                 tricks: section.tricks,
                                                 completed: section.completed ?? 0,
                                                 collapsed: section.collapsed,
                                                 onTap: { name in
                                                    self.vm.toggleSection(name: name)
                                                 }
                    )
                    Section(header: header) {
                        ForEach(section.rows) { row in
                            ZStack {
                                TrickCellView(name: row.title,
                                              level: row.levels[.ijru] ?? nil,
                                              done: row.isDone)
                                NavigationLink(destination: Text(row.title)) {
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
            }
            .animation(.linear(duration: 0.2))
            .navigationBarTitle("Tricks", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        picker = .disciplines
                                        pickerPresented = true
                                    }, label: {
                                        Text(self.vm.disciplines[self.vm.selectedDiscipline].name)
                                    }),
                                trailing:
                                    Button(action: {
                                        picker = .levels
                                        pickerPresented = true
                                    }, label: {
                                        Text("Level \(self.vm.selectedLevel)")
                                    })
            )
        }
        .actionSheet(isPresented: $pickerPresented) {
            self.getSheet(for: picker)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func getSheet(for picker: Picker) -> ActionSheet {
        switch picker {
        case .levels:
            return makeLevelPickerSheet()
        case .disciplines:
            return makeDisciplinePickerSheet()
        }
    }
    
    private func makeLevelPickerSheet() -> ActionSheet {
        var actionSheetButtons: [ActionSheet.Button] = vm.levels.map { level in
            .default(Text("Level \(level)"), action: { self.vm.selectedLevel = level })
        }
        actionSheetButtons.append(.cancel())
        return ActionSheet(title: Text("Level picker"), message: Text("Select level"), buttons: actionSheetButtons)
    }
    
    private func makeDisciplinePickerSheet() -> ActionSheet {
        var actionSheetButtons: [ActionSheet.Button] = vm.disciplines.map { discipline in
            .default(Text(discipline.name), action: { self.vm.selectedDiscipline = self.vm.disciplines.index(of: discipline) ?? 0 })
        }
        actionSheetButtons.append(.cancel())
        return ActionSheet(title: Text("Discipline picker"), message: Text("Select discipline"), buttons: actionSheetButtons)
    }
    
    private enum Picker {
        case levels, disciplines
    }
}
