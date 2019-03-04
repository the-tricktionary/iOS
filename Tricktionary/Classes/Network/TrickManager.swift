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

class TrickManager {
    
    static var shared: TrickManager {
        get {
            return TrickManager()
        }
    }

    func getTricks(starting: @escaping () -> (),completion: @escaping ([String : Any]) -> Void, finish: @escaping () -> Void) {
        starting()
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR")
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
    }
    
    func getTrickByName(name: String, starting: @escaping () -> (), completion: @escaping ([String : Any]) -> Void, finish: @escaping () -> Void) {
        starting()
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
            
            finish()
        }
    }

    func getTrickNameById(id: String, completion: @escaping ([String : Any]) -> Void, finish: @escaping () -> Void) {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR").document(id)
        documentReference.getDocument { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            completion(snapshot.data()!)
            finish()
        }
    }
}

class TrickService {

    
    func getTrickNameById(id: String, completion: @escaping ([String : Any]) -> Void) {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR").document(id)
        documentReference.getDocument { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            completion(snapshot.data()!)
        }
    }
}
