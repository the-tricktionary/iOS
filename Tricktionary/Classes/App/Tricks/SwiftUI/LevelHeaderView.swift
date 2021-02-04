//
//  LevelHeaderView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 23/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import SwiftUI

struct LevelHeaderView: View {
    
    let title: String
    let tricks: Int
    let completed: Int
    var collapsed: Bool
    var onTap: ((String) -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title.lowercased())
                .foregroundColor(.white)
                .padding(.leading, 16)
            Spacer()
            Text("\(completed)/\(tricks)")
                .font(.system(size: 12))
                .foregroundColor(.white)
            Image(collapsed ? "collapsed" : "expansed")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(.trailing, 16)
        }
        .padding([.top, .bottom], 20)
        .background(SwiftUI.Color.yellow)
        .padding([.leading, .trailing], -20)
        .onTapGesture {
            self.onTap?(title)
        }
    }
}

struct LevelHeaderContent {
    let title: String
    let tricks: Int
    let completed: Int
    var collapsed: Bool
}
