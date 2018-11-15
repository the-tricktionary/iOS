//
//  TricksViewModel.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ReactiveSwift

class TricksViewModel {
    
    var tricks: MutableProperty<[Trick]> = MutableProperty<[Trick]>([])
    var level1: MutableProperty<[Trick]> = MutableProperty<[Trick]>([])
    
    // MARK: Variables
    
    // MARK: Life cycles
    
    // MARK: Privates
    
    // MARK: Publics
    
    func getTricks() {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR")
        documentReference.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            guard let snapshot = snapshot, snapshot.isEmpty == false else {
                return
            }
            
            let decoder = JSONDecoder()
            
            snapshot.documents.forEach({ (document) in
                let dictionary = document.data()
                do {
                    let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                    let trick = try decoder.decode(Trick.self, from: data)
                    self.tricks.value.append(trick)
                } catch {
                    print(error.localizedDescription)
                }
            })
            self.level1.value = self.tricks.value.filter { $0.level == 1 }
        }
    }
    
}
