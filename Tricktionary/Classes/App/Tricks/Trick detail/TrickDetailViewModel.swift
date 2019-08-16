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
}

class TrickDetailViewModel: TrickDetailViewModelType {
    
    // MARK: Variables
    
    var onLoad: (() -> Void)?
    var onStartLoading: (() -> Void)?
    
    var trick: Trick?
    var trickName: String
//    var loaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
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
            self.trick = Trick(trick)
            self.trick?.getPrerequisites(finish: { [weak self] in
                self?.onLoad?()
            })
        }) { [weak self] in
            self?.onLoad?()
        }
    }
}
