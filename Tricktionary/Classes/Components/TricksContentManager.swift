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

class TricksContentManager {
    
    // MARK: - Variables
    // public
    var completedTricks: [String] = []
    
    // private
    private let userManager: UserManagerType
    private let chcecklistDataProvider: ChecklistDataProviderType
    private var cancelables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(userManager: UserManagerType, checklistDataProvider: ChecklistDataProviderType) {
        self.userManager = userManager
        self.chcecklistDataProvider = checklistDataProvider
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
