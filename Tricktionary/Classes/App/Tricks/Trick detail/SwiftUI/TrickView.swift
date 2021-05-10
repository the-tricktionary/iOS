//
//  TrickView.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 25/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import SwiftUI
import Resolver
import Kingfisher

struct TrickView: View {
    
    var name: String
    var ijruLevel: String?
    @InjectedObject var vm: TrickDetailViewModel
    
    init(name: String, ijruLevel: String?) {
        self.name = name
        self.ijruLevel = ijruLevel
    }
    
    var body: some View {
            VStack {
                KFImage(vm.videoThumbnail)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        Button(action: {
                            print("Play tapped")
                        }, label: {
                            Image("video-play")
                                .resizable()
                                .frame(width: 50, height: 50)
                        })
                    )
                ScrollView {
                    TrickInfoView(name: vm.uiTrick?.name ?? "",
                                  ijruLevel: vm.uiTrick?.levels?.ijru.level ?? nil,
                                  done: $vm.isDone) { isDone in
                        vm.markTrickAsDone(vm.uiTrick?.id ?? "",
                                           done: isDone)
                    }
//                    self.vm.uiPreprequisites.map { prereq in
//                        VStack {
//                            Button(action: {
//                                if self.vm.uiPreprequisites?.isEmpty == true {
//                                    self.vm.uiPreprequisites = self.vm.preprequisites.value
//                                } else {
//                                    self.vm.uiPreprequisites = []
//                                }
//                            }, label: {
//                                RequirementsButton(label: "Prerequisites",
//                                                   collapsed: self.vm.uiPreprequisites?.isEmpty == true)
//                                    .padding([.leading, .trailing], 16)
//                                    .background(Rectangle()
//                                                    .fill(SwiftUI.Color.white).shadow(radius: 1)
//                                                    .padding([.leading, .trailing], 16))
//                            })
//                            ForEach(prereq, id: \.self) { prer in
//                                HStack {
//                                    Text(prer.name)
//                                        .padding(.leading, 32)
//                                        .padding([.top, .bottom], 10)
//                                    Spacer()
//                                }
//                                .padding(.top, 0)
//                                .background(Rectangle()
//                                .fill(SwiftUI.Color.white).shadow(radius: 1)
//                                .padding([.leading, .trailing], 16))
//                            }
//                        }
//                    }
                    Text(vm.uiTrick?.description ?? "")
                        .padding([.leading, .trailing], 16)
                        .padding(.top, 16)
                        .font(.system(size: 13))
                }
                Spacer()
                .navigationBarTitle(self.name)
            }
            .onAppear(perform: {
                self.vm.getTrick(by: self.name)
            })
    }
}

struct RequirementsButton: View {
    let label: String
    var collapsed: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.black)
                .padding(.leading, 16)
                .padding([.top, .bottom], 10)
            Spacer()
            Image(collapsed ? "collapsed" : "expansed")
                .resizable()
                .frame(width: 25, height: 25)
                .accentColor(.gray)
                .padding(.trailing, 16)
        }
    }
}

struct TrickInfoView: View {
    
    var name: String
    var ijruLevel: String?
    @Binding var done: Bool
    var doneDidTap: ((Bool) -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text(name)
                            .padding([.leading, .top], 16)
                        Spacer()
                    }
                    HStack {
                        Image("ijru")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.leading, 16)
                        ijruLevel.map { level in
                            Text(level)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                }
                Spacer()
                VStack {
                    Button(action: {
                        doneDidTap?(!done)
                    }, label: {
                        Image(done ? "done" : "done-outline")
                            .resizable()
                            .frame(width: 27, height: 27)
                    }).padding(.trailing, 16)
                }
            }
        }
    }
}
