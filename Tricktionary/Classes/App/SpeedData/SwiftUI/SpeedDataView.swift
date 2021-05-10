//
//  SpeedDataView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 02.03.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Resolver
import SwiftUI
 
struct SpeedDataView: View {
    
    @InjectedObject var viewModel: SpeedDataViewModel
    
    init() {
        viewModel.getSpeedData {
            //
        } finish: {
            //
        }
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.speeds) { speed in
                ZStack {
                    SpeedEventCellView(eventName: speed.name ?? "No name",
                                       score: speed.score,
                                       misses: speed.misses,
                                       noMiss: speed.noMissScore)
                    NavigationLink(destination: Text(speed.name ?? "No name")) {
                        EmptyView()
                    }
                    .opacity(0)
                }
            }.navigationBarTitle("Speed data", displayMode: .inline)
        }
    }
}

struct SpeedEventCellView: View {
    
    let eventName: String
    let score: Int
    let misses: Int
    let noMiss: Int
    
    var body: some View {
        Group {
            HStack {
                VStack {
                    HStack {
                        Text(eventName)
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    HStack {
                        Text("Misses: \(misses)")
                            .font(.system(size: 14))
                        Spacer()
                    }
                    HStack {
                        Text("No miss score: \(noMiss)")
                            .font(.system(size: 14))
                        Spacer()
                    }
                }
                Text("\(score)")
                    .font(.system(size: 25))
                    .foregroundColor(.red)
            }
        }
        .padding([.top, .bottom], 5)
    }
}
