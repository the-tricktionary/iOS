//
//  TrickListView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 22/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import SwiftUI
import Resolver

struct TrickListView: View {
    @State var pickerPresented = false
    @State private var picker: Picker = .levels
    
    @InjectedObject var viewModel: TricksViewModel
    
    init() {
        self.viewModel.getTricks(silent: false)
        
    }
        
    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $viewModel.searchText)
                    .padding([.leading, .trailing], -20)
                    .padding([.top, .bottom], -7)
                ForEach(viewModel.uiSections) { section in
                    let header = LevelHeaderView(title: section.name,
                                                 tricks: section.tricks,
                                                 completed: section.completed ?? 0,
                                                 collapsed: section.collapsed,
                                                 onTap: { name in
                                                    self.viewModel.toggleSection(name: name)
                                                 }
                    )
                    Section(header: header) {
                        ForEach(section.rows) { row in
                            ZStack {
                                TrickCellView(name: row.title,
                                              level: row.levels[.ijru] ?? nil,
                                              done: row.isDone)
                                NavigationLink(destination: TrickView(name: row.title,
                                                                      ijruLevel: row.levels[.ijru] ?? nil,
                                                                      done: row.isDone)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                self.viewModel.getTricks(silent: true)
            })
            .listStyle(PlainListStyle())
            .animation(.default)
            .navigationBarTitle("Tricks", displayMode: .automatic)
            .navigationBarItems(leading:
                                    Button(action: {
                                        picker = .disciplines
                                        pickerPresented = true
                                    }, label: {
                                        Text(self.viewModel.disciplines[self.viewModel.selectedDiscipline].name)
                                    }),
                                trailing:
                                    Button(action: {
                                        picker = .levels
                                        pickerPresented = true
                                    }, label: {
                                        Text("Level \(self.viewModel.selectedLevel)")
                                    })
            )
        }
        .background(SwiftUI.Color.red)
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
        var actionSheetButtons: [ActionSheet.Button] = viewModel.levels.map { level in
            .default(Text("Level \(level)"), action: { self.viewModel.selectedLevel = level })
        }
        actionSheetButtons.append(.cancel())
        return ActionSheet(title: Text("Level picker"), message: Text("Select level"), buttons: actionSheetButtons)
    }
    
    private func makeDisciplinePickerSheet() -> ActionSheet {
        var actionSheetButtons: [ActionSheet.Button] = viewModel.disciplines.map { discipline in
            .default(Text(discipline.name), action: { self.viewModel.selectedDiscipline = self.viewModel.disciplines.index(of: discipline) ?? 0 })
        }
        actionSheetButtons.append(.cancel())
        return ActionSheet(title: Text("Discipline picker"), message: Text("Select discipline"), buttons: actionSheetButtons)
    }
    
    private enum Picker {
        case levels, disciplines
    }
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = Color.red
        searchBar.placeholder = "Search trick"
        searchBar.tintColor = .white
        searchBar.barTintColor = .red
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
