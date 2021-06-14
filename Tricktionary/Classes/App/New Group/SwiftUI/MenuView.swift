//
//  MenuView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 02.03.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Resolver
import SwiftUI

struct MenuView: View {
    
    @InjectedObject var vm: MenuViewModel
    @State var activeSheet: Row?
    
    var body: some View {
        NavigationView {
            List {
                makeAccountView()
                    .onTapGesture(perform: {
                        activeSheet = .account
                    })
                ForEach(vm.rows) { row in
                    Button(action: {
                        handleAction(for: row)
                    }) {
                        makeRow(row)
                    }
                }
            }
            .navigationBarTitle("Menu", displayMode: .inline)
        }
        .sheet(item: $activeSheet, content: { item in
            switch item {
            case .account:
                if vm.userManager.logged {
                    NavigationView {
                        Text("Hello \(vm.userManager.userName ?? "No name")")
                            .navigationBarTitle("User profile", displayMode: .inline)
                    }
                } else {
                    NavigationView {
                        LoginVC(onClose: {
                            self.activeSheet = nil
                        })
                            .navigationBarTitle("Login", displayMode: .inline)
                    }
                }
            case .setting:
                SettingsView()
            default:
                EmptyView()
            }
        })
    }
    
    private func makeRow(_ row: RowContent) -> some View {
        HStack {
            Image(row.iconName)
            VStack {
                HStack {
                    Text(row.title)
                    Spacer()
                }
                HStack {
                    Text(row.description)
                        .font(.system(size: 12, weight: .thin))
                    Spacer()
                }
            }
        }
    }
    
    private func makeAccountView() -> some View {
        AccountView(userImageData: vm.userManager.imageData,
                    userName: vm.userManager.userName,
                    email: vm.userManager.email)
    }
    
    private func handleAction(for row: RowContent) {
        switch row.rowType {
        case .instagram, .web:
            if let url = URL(string: row.url ?? "") {
               UIApplication.shared.open(url)
           }
        case .setting:
            self.activeSheet = .setting
        case .logout:
            vm.userManager.logout()
        default:
            break
        }
    }
}

struct AccountView: View {
    let userImageData: Data?
    let userName: String?
    let email: String?

    var body: some View {
        HStack {
            makeImage()
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(35)
            if userName != nil {
                Text(userName ?? "")
            } else {
                Text("Sign in")
            }
        }.padding([.top, .bottom], 5)
    }
    
    private func makeImage() -> Image {
        if let imageData = userImageData, let image = UIImage(data: imageData) {
            return Image(uiImage: image)
        } else {
            return Image("signin")
        }
    }
}
