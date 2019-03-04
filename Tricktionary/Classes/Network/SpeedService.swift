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
    
    func getSpeedData(starting: @escaping () -> Void, completion: @escaping (Speed) -> Void, finish: @escaping () -> Void) {
        starting()
        let firestore = Firestore.firestore()
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
}

class SpeedService {

    func createSpeedEvent() {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else {
            return
        }
        let firestore = Firestore.firestore()
        var ref: DocumentReference?
        ref = firestore.collection("speed").addDocument(data: [
            "avgJumps": 3,
            "created": Date(),
            "event": "WJR 30s",
            "jumpLost": 3,
            "maxJumps": 4,
            "misses": 2,
            "name": "iOS TEST data new",
            "noMissScore": 85,
            "score": 80,
            "duration": 2,
            "uid": uid,
            "graphData": []
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Pridal jsem test speed data: \(ref!.documentID)")
            }
        }
    }
    
    func saveSpeedEvent(speed: Speed) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else {
            return
        }
        speed.uid = uid
        let firestore = Firestore.firestore()
        var ref: DocumentReference?
        ref = firestore.collection("speed").addDocument(data: speed.getDictionary()) { error in
            if let error = error {
                print("Error saving speed data document: \(error.localizedDescription)")
            } else {
                print("Speed data document saved: \(ref?.documentID)")
            }
        }
    }
    
    func getSpeedData(completion: @escaping (Speed) -> Void, finish: @escaping () -> Void) {
        let firestore = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let id = user?.uid {
            print("MAM USER ID A JEDU DATA")
            let documentReference = firestore.collection("speed").whereField("uid", isEqualTo: id)
            documentReference.getDocuments { (snapshot, error) in
                if error != nil {
                    print("MAM TU ERROR")
                    print(error?.localizedDescription ?? "Some error")
                }
                
                guard let snapshot = snapshot else {
                    print("NEMAM SNAP SHOT")
                    return
                }
                
                let decoder = JSONDecoder()
                snapshot.documents.forEach({ (document) in
                    let dictionary = document.data()
                    do {
                        let speed = Speed(data: dictionary)
                        completion(speed)
                    } catch {
                        print(error.localizedDescription)
                    }
                })
                finish()
            }
        }
    }
}
