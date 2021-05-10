//
//  TricksContentManager.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 15/11/2020.
//  Copyright © 2020 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine
import Resolver

protocol TricksContentManagerType {
    var completedTricks: [String] { get }
}

class TricksContentManager: TricksContentManagerType {
    
    // MARK: - Variables
    // public
    var completedTricks: [String] = []
    
    // private
    @Injected var userManager: UserManagerType
    @Injected var chcecklistDataProvider: ChecklistDataProviderType
    private var cancelables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init() {
        bind()
    }
    
    // MARK: - Privates
    private func bind() {
        userManager.userStateDidChange.sink { [unowned self] logged in
            if logged {
                self.getCheckList()
            } else {
                completedTricks.removeAll()
            }
        }.store(in: &cancelables)
    }
    
    private func getCheckList() {
        chcecklistDataProvider.getChecklist().sink { (completion) in
            print("Completed \(completion)")
        } receiveValue: { checklist in
            self.completedTricks = checklist
        }.store(in: &cancelables)
    }
}
