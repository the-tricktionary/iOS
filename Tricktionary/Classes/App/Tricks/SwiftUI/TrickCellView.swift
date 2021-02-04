//
//  TrickCellView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 23/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import SwiftUI

struct TrickCellView: View {
    
    var name: String
    var level: String?
    var done: Bool?
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(name)
                        .padding(.top, 17)
                    Spacer()
                }
                level.map { level in
                    HStack {
                        Image("ijru")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(.bottom, 13)
                        Text(level)
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .padding(.bottom, 13)
                        Spacer()
                    }
                }
            }
            Spacer()
            Image(done == true ? "done" : "empty")
                .resizable()
                .frame(width: 27, height: 27)
                .padding(.top, 24)
                .padding(.bottom, 19)
        }
    }
}
