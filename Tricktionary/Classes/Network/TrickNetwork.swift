//
//  TrickNetwork.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 18/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import RxFirestoreExecutor
import RxSwift

class TrickNetwork {
    
    // MARK: Variables
    
    let executor = QueryExecutor<TrickService>()
    
    // MARK: Public
    
    func getTricks() {
        executor.request(.listData())
            .subscribe(onSuccess: { (value) in
                print("USPESNE PROVEDEN REQUEST DO FIRESTORE: \(value)")
            }) { (error) in
                print("CHYBAAAAAAAAAAAAAAA")
            }.dispose()
    }
}
