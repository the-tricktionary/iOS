//
//  TrickService.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ReactiveSwift
import RxSwift

class TrickService {


    func getTricksByLevel(completion: @escaping ([String : Any]) -> Void, finish: @escaping () -> Void) {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR") //.whereField("level", isEqualTo: level)
        documentReference.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }

            guard let snapshot = snapshot, snapshot.isEmpty == false else {
                return
            }

            snapshot.documents.forEach({ (document) in
                completion(document.data())
            })
            
            finish()
        }
        finish()
    }
    
    func getTrickByName(name: String, completion: @escaping ([String : Any]) -> Void) {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR").whereField("name", isEqualTo: name)
        documentReference.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }
            
            guard let snapshot = snapshot, snapshot.isEmpty == false else {
                return
            }
            
            snapshot.documents.forEach({ (document) in
                completion(document.data())
            })
        }
    }
}
