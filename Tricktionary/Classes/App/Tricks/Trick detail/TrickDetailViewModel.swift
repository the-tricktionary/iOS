//
//  TrickDetailViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol TrickDetailViewModelType {
    var onLoad: (() -> Void)? { get set }
    var onStartLoading: (() -> Void)? { get set }
    func getTrick()
    var trick: Trick? { get set }
    var autoPlay: Bool { get }
    var fullscreen: Bool { get }
}

class TrickDetailViewModel: TrickDetailViewModelType {
    
    // MARK: Variables
    @Persistent(key: PxSettings.autoplay, defaultValue: false)
    var autoPlay: Bool

    @Persistent(key: PxSettings.fullscreen, defaultValue: false)
    var fullscreen: Bool

    var onLoad: (() -> Void)?
    var onStartLoading: (() -> Void)?
    
    var trick: Trick?
    var video: Video?
    var trickName: String
    var loadedPrerequisites: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    // MARK: Life cycles
    
    init(trick: String) {
        self.trickName = trick
    }
    
    // MARK: Public
    
    func getTrick() {
        TrickManager.shared.getTrickByName(name: trickName,
                                           starting: { [weak self] in
                                            self?.onStartLoading?()
        }, completion: { (trick) in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: trick["videos"], options: [])
                let video = try JSONDecoder().decode(Video.self, from: jsonData)
                self.video = video
                self.onLoad?()
            } catch {
                print("PICU")
            }
        }) { [weak self] in
            self?.onLoad?()
        }
    }
}
