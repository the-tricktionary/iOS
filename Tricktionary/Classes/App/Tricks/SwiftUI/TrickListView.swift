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
import Combine

struct TrickListView: View {
    @State var pickerPresented = false
    @State private var picker: Picker = .levels
    
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    @InjectedObject var viewModel: TricksViewModel

    var cancelable = Set<AnyCancellable>()
    
    init() {
        self.viewModel.getTricks(silent: false)
    }
        
    var body: some View {
        NavigationView {
            self.makeListView()
                .add(self.searchBar)
                .onAppear(perform: {
                    self.viewModel.getTricks(silent: true)
                })
                .listStyle(PlainListStyle())
                .animation(.default)
                .navigationBarTitle("Tricks", displayMode: .inline)
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
                .actionSheet(isPresented: $pickerPresented) {
                    self.getSheet(for: picker)
                }
        }
        .background(SwiftUI.Color.red)
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
    
    private func makeListView() -> some View {
        List {
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
                    ForEach(section.rows.filter { $0.title.lowercased().contains(self.searchBar.text.lowercased()) || self.searchBar.text.isEmpty }) { row in
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
        .padding(.top, -8)
    }
    
    private enum Picker {
        case levels, disciplines
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
            outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

struct SearchBarView: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(SwiftUI.Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                 
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                )
 
            if isEditing {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil,
                                                    from: nil,
                                                    for: nil)
                    self.isEditing = false
                    self.text = ""
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

class SearchBar: NSObject, ObservableObject {
    
    @Published var text: String = ""
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
    }
}

extension SearchBar: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
        }
    }
}

struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                    .frame(width: 0, height: 0)
            )
    }
}

extension View {
    
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}

final class ViewControllerResolver: UIViewControllerRepresentable {
    
    let onResolve: (UIViewController) -> Void
        
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
    }
    
    func makeUIViewController(context: Context) -> ParentResolverViewController {
        ParentResolverViewController(onResolve: onResolve)
    }
    
    func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
}

class ParentResolverViewController: UIViewController {
    
    let onResolve: (UIViewController) -> Void
    
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }
        
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent {
            onResolve(parent)
        }
    }
}
