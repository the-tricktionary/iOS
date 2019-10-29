//
//  SpeedService.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 21/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ReactiveSwift
import FirebaseAuth

class SpeedManager {
    
    static var shared: SpeedManager {
        get {
            return SpeedManager()
        }
    }
    
    fileprivate let firestore = Firestore.firestore()
    
    func getSpeedData(starting: @escaping () -> Void, completion: @escaping (Speed) -> Void, finish: @escaping () -> Void) {
        starting()
//        let firestore = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let id = user?.uid {
            let documentReference = firestore.collection("speed").whereField("uid", isEqualTo: id)
            documentReference.getDocuments { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Some error")
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                snapshot.documents.forEach({ (document) in
                    let dictionary = document.data()
                    let speed = Speed(data: dictionary)
                    completion(speed)
                })
                finish()
            }
        }
    }
    
    func saveSpeedEvent(speed: Speed) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else {
            return
        }
        speed.uid = uid
        var _ = firestore.collection("speed").addDocument(data: speed.getDictionary()) { error in
            if let error = error {
                print("Error saving speed data document: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSpeedEvent(speed: Speed, completed: @escaping () -> Void) {
        guard let _ = Auth.auth().currentUser?.uid else { return }
        guard speed.created != nil else {
            return
        }
        var _ = firestore.collection("speed").document(speed.created!.description).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                completed()
            }
        }
    }
}
