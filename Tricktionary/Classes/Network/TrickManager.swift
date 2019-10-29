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
import FirebaseAuth
import FirebaseRemoteConfig

enum Disciplines {
    case singleRope, wheels, doubleDutch

    var identity: String {
        switch self {
        case .singleRope:
            return "tricksSR"
        case .wheels:
            return "tricksWH"
        case .doubleDutch:
            return "tricksDD"
        }
    }

    var name: String {
        switch self {
        case .singleRope:
            return "Single rope"
        case .wheels:
            return "Wheels"
        case .doubleDutch:
            return "Double dutch"
        }
    }
}

protocol TricksDataProviderType {
    
    func getTricks(discipline: Disciplines, starting: @escaping () -> (),completion: @escaping (Trick) -> Void, finish: @escaping () -> Void)
    func getChecklist(starting: @escaping () -> Void, completion: @escaping ([String]?) -> Void, finish: @escaping () -> Void)
}

class TrickManager: TricksDataProviderType {
    func getTricks(discipline: Disciplines, starting: @escaping () -> (), completion: @escaping (Trick) -> Void, finish: @escaping () -> Void) {
        starting()
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection(discipline.identity)
        documentReference.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }

            guard let snapshot = snapshot, snapshot.isEmpty == false else {
                return
            }

            snapshot.documents.forEach({ (document) in
                var data = document.data()
                data.removeValue(forKey: "prerequisites")
                data.removeValue(forKey: "i18n")
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let trick = try JSONDecoder().decode(Trick.self, from: jsonData)
                    completion(trick)
                } catch {
                    print("Deserialize error: \(error.localizedDescription)")
                }
            })

            finish()
        }
    }

    func getChecklist(starting: @escaping () -> Void, completion: @escaping ([String]?) -> Void, finish: @escaping () -> Void) {
        starting()
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            finish()
            return
        }
        let firestore = Firestore.firestore()
        let reference = firestore.collection("checklist").document(user.uid)
        reference.getDocument { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }

            guard let snapshot = snapshot else {
                finish()
                return
            }
            completion(snapshot.data()?["SR"] as? [String])
            finish()
        }
    }

    
    static var shared: TrickManager {
        get {
            return TrickManager()
        }
    }

    func loadRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings()

        remoteConfig.setDefaults([
            "singlerope": true as NSObject,
            "wheels": false as NSObject,
            "doubledutch": false as NSObject
        ])

        remoteConfig.fetch(withExpirationDuration: 0) { (status, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if status == .success {
                remoteConfig.activateFetched()
            }
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
