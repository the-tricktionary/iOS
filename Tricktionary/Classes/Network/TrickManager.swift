//
//  TrickService.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase
import ReactiveSwift
import RxSwift
import FirebaseAuth
import FirebaseRemoteConfig
import CodableFirebase
import Combine

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
    //, starting: @escaping () -> (),completion: @escaping (BaseTrick, String) -> Void, finish: @escaping () -> Void
    func getTricks(discipline: Disciplines) -> AnyPublisher<[BaseTrick], Error>
    func getChecklist() -> AnyPublisher<[String], Error>
}

class TrickManager: TricksDataProviderType {
    func getTricks(discipline: Disciplines) -> AnyPublisher<[BaseTrick], Error> {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection(discipline.identity)
        let publisher = PassthroughSubject<[BaseTrick], Error>()
        documentReference.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }
            
            guard let snapshot = snapshot, snapshot.isEmpty == false else {
                publisher.send(completion: .failure(NSError(domain: "Error", code: 1, userInfo: nil) as Error))
                return
            }
            var list: [BaseTrick] = []
            snapshot.documents.forEach({ (document) in
                let data = document.data()
                var trick = BaseTrick(data: data)
                trick.id = document.documentID
                list.append(trick)
//                completion(trick, document.documentID)
            })
            publisher.send(list)
//            finish()
        }
        return publisher.eraseToAnyPublisher()
    }

    func getChecklist() -> AnyPublisher<[String], Error> {
        let publisher = CurrentValueSubject<[String], Error>([])
        guard let user = Auth.auth().currentUser else {
            return publisher.eraseToAnyPublisher()
        }
        let firestore = Firestore.firestore()
        let reference = firestore.collection("checklist").document(user.uid)
        
        reference.getDocument { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }

            guard let snapshot = snapshot else {
                publisher.send(completion: .failure(NSError(domain: "Error", code: 0, userInfo: nil) as Error))
                return //NSError(domain: "Error", code: 0, userInfo: nil) as Error
            }
            publisher.send((snapshot.data()?["SR"] as? [String]) ?? [])
//            return Just<[String]>((snapshot.data()?["SR"] as? [String]) ?? []).eraseToAnyPublisher()
//            completion(snapshot.data()?["SR"] as? [String])
//            finish()
        }
        return publisher.eraseToAnyPublisher()
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
    
    func getTrickByName(name: String, starting: @escaping () -> (), completion: @escaping (Trick) -> Void, finish: @escaping () -> Void) {
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
                var data = document.data()
                if var prer = data["prerequisites"] as? [[String : Any]] {
                    data.removeValue(forKey: "prerequisites")
                    for (index, _) in prer.enumerated() {
                        prer[index].removeValue(forKey: "ref")
                    }
                    data["prerequisites"] = prer
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    var trick = try JSONDecoder().decode(Trick.self, from: jsonData)
                    trick.id = document.documentID
                    completion(trick)
                } catch {
                    print("PICU")
                }

            })
            
            finish()
        }
    }

    func markTrickAsDone(isDone: Bool, id: String) {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let firestore = Firestore.firestore()
        if !isDone {
            firestore.collection("checklist").document(user.uid).updateData([
                "SR" : FieldValue.delete()
            ]) { error in
                if error == nil {
                    print("Trick \(id) marked as \(isDone ? "done" : "not done")")
                } else {
                    print("Trick marking error \(error?.localizedDescription)")
                }
            }
        }
    }

    func getTrickById(id: String, completion: @escaping (Trick) -> Void, finish: @escaping () -> Void) {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR").document(id)
        documentReference.getDocument { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }
            
            guard let snapshot = snapshot else {
                return
            }
            guard var data = snapshot.data() else {
                return
            }
            data.removeValue(forKey: "prerequisites")
            print("### MAM: \(data["name"])")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let trick = try JSONDecoder().decode(Trick.self, from: jsonData)
                completion(trick)
            } catch {
                print("PICU")
            }
            
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
