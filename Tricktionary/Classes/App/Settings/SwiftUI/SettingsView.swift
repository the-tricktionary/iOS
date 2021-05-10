//
//  SettingsView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 09.03.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import SwiftUI
import Resolver
import Combine

struct SettingsView: View {
    
    @InjectedObject var vm: SettingsViewModel
    
    private var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Video settings")) {
                    HStack {
                        Text("Automatic full screen")
                        Spacer()
                        Toggle(isOn: $vm.autoFullscreen, label: {
                            EmptyView()
                        })
                    }
                    HStack {
                        Text("Automatic play vieo")
                        Spacer()
                        Toggle(isOn: $vm.autoplay, label: {
                            EmptyView()
                        })
                    }
                }
                Section(header: Text("Tricktionary settings")) {
                    HStack {
                        Text("Show IJRU")
                        Spacer()
                        Toggle(isOn: $vm.ijru, label: {
                            EmptyView()
                        })
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}
