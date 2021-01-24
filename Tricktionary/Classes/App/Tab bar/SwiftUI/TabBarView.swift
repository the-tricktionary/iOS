//
//  TabBarView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 22/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import SwiftUI

struct TabBarView: View {

    var body: some View {
        
        TabView {
            TrickListView()
                .tabItem {
                    Image("tricktionary")
                    Text("Tricks")
                }
            Text("Here will be speed timer")
                .tabItem {
                    Image("timer")
                    Text("Speed timer")
                }
            
            Text("Here will be speed data")
                .tabItem {
                    Image("data")
                    Text("Speed data")
                }
            
            Text("Here will be submit video")
                .tabItem {
                    Image("submit")
                    Text("Submit")
                }
            
            Text("Here will be menu")
                .tabItem {
                    Image("settings")
                    Text("Menu")
                }
        }
        .accentColor(.yellow)
    }
}
