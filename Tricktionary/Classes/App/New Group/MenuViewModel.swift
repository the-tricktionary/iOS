//
//  MenuViewModel.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 03.03.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Combine
import Resolver

struct RowContent: Identifiable {
    var id = UUID().uuidString
    
    let iconName: String
    let title: String
    let description: String
    let rowType: Row
    var url: String? = nil
}

enum Row: Identifiable {
    var id: String {
        UUID().uuidString
    }
    case account
    case instagram
    case web
    case contact
    case writer
    case setting
    case logout
}

class MenuViewModel: ObservableObject {
    // MARK: - Variables
    @Injected var userManager: UserManagerType
    @Injected var trickManager: TricksContentManagerType
    
    @Published var rows: [RowContent] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        self.makeRows()
        self.bind()
    }
    
    private func makeRows() {
        if userManager.logged {
            rows = [
                RowContent(iconName: "instagram",
                           title: "Instagram",
                           description: "@the-tricktionary",
                           rowType: .instagram,
                           url: "http://instagram.com/jumpropetricktionary"),
                RowContent(iconName: "web",
                           title: "Web",
                           description: "www.the-tricktionary.com",
                           rowType: .web,
                           url: "http://www.the-tricktionary.com"),
                RowContent(iconName: "contact",
                           title: "Contact",
                           description: "Contact your coach",
                           rowType: .contact),
                RowContent(iconName: "writer",
                           title: "Writer",
                           description: "Write something",
                           rowType: .writer),
                RowContent(iconName: "settings",
                           title: "Settings",
                           description: "Customize trick list and video options",
                           rowType: .setting),
                RowContent(iconName: "clear",
                           title: "Logout",
                           description: "Sign out",
                           rowType: .logout)
            ]
        } else {
            rows = [
                RowContent(iconName: "instagram",
                           title: "Instagram",
                           description: "@the-tricktionary",
                           rowType: .instagram,
                           url: "http://instagram.com/jumpropetricktionary"),
                RowContent(iconName: "web",
                           title: "Web",
                           description: "www.the-tricktionary.com",
                           rowType: .web,
                           url: "http://www.the-tricktionary.com"),
                RowContent(iconName: "settings",
                           title: "Settings",
                           description: "Customize trick list and video options",
                           rowType: .setting)
            ]
        }
    }
    
    private func bind() {
        userManager.userStateDidChange.sink { _ in
            self.makeRows()
        }.store(in: &cancellable)
    }
}
