//
//  TrickService.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 16/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseRemoteConfig
import Combine
import Apollo

// TODO: Use cases with injected repositories

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
    func getTricks(discipline: Disciplines) -> AnyPublisher<[BaseTrick], Error>
    func getChecklist() -> AnyPublisher<[String], Error>
}

protocol TrickDetailDataProviderType {
    func getTrickByName(name: String) -> AnyPublisher<Trick, Error>
    func getPrerequisites(ids: [Prerequisites]) -> AnyPublisher<Trick, Error>
    func getTrickById(_ id: String) -> AnyPublisher<Trick, Error>
}

protocol ChecklistDataProviderType {
    func getChecklist() -> AnyPublisher<[String], Error>
}

class TrickManager: TricksDataProviderType, TrickDetailDataProviderType, ChecklistDataProviderType {
    func getTricks(discipline: Disciplines) -> AnyPublisher<[BaseTrick], Error> {
        var tricks: [BaseTrick]?
        let publisher = PassthroughSubject<[BaseTrick], Error>()
        var disc: Discipline {
            switch discipline {
            case .singleRope:
                return .singleRope
            case .wheels:
                return .wheel
            case .doubleDutch:
                return .doubleDutch
            }
        }
        Network.shared.apollo.fetch(query: TrickListQuery(tricksDiscipline: disc)) { result in
            switch result {
            case let .success(data):
                tricks = data.data?.tricks.compactMap { trick in
                    let tricktionaryLevel = trick.levels.first { $0.organisation == "tricktionary" }?.level ?? "0"
                    let levels = trick.levels.reduce(into: [String: Any]()) { result, level in
                        if level.organisation != "tricktionary" {
                            result[level.organisation] = level.level
                        }
                    }
                    return BaseTrick(name: trick.localisation?.name ?? "-",
                                     level: Int(tricktionaryLevel) ?? 0,
                                     type: trick.trickType.rawValue,
                                     levels: Levels(levels),
                                     id: trick.id)
                }
                publisher.send(tricks ?? [])
            case let .failure(error):
                publisher.send(completion: .failure(error))
            }
        }
        return publisher.eraseToAnyPublisher()
    }

    func getChecklist() -> AnyPublisher<[String], Error> {
        let publisher = PassthroughSubject<[String], Error>()
        guard let user = Auth.auth().currentUser else {
            publisher.send([])
            return publisher.eraseToAnyPublisher()
        }
        let firestore = Firestore.firestore()
        let reference = firestore.collection("checklist").document(user.uid)
        
        reference.getDocument { snapshot, error in
            if let error = error {
                publisher.send(completion: .failure(error))
                print(error.localizedDescription)
            }

            guard let snapshot = snapshot else {
                publisher.send(completion: .failure(NSError(domain: "Error", code: 0, userInfo: nil) as Error))
                return
            }
            publisher.send((snapshot.data()?["SR"] as? [String]) ?? [])
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
            "doubledutch": false as NSObject,
            "ios_swiftUI": true as NSObject
        ])

        remoteConfig.fetch(withExpirationDuration: 0) { (status, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if status == .success {
                remoteConfig.activate { (_, error) in
                    if let error = error {
                        print("Error while activating fetched config \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getTrickByName(name: String) -> AnyPublisher<Trick, Error> {
        let firestore = Firestore.firestore()
        let publisher = PassthroughSubject<Trick, Error>()
        let documentReference = firestore.collection("tricksSR").whereField("name", isEqualTo: name)
        documentReference.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
            }
            
            guard let snapshot = snapshot, snapshot.isEmpty == false else {
                publisher.send(completion: .failure(NSError(domain: "Error", code: 1, userInfo: nil) as Error))
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
                    var trick = Trick(data)
                    trick.id = document.documentID
                    publisher.send(trick)
                } catch {
                    publisher.send(completion: .failure(error))
                }

            })
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func getPrerequisites(ids: [Prerequisites]) -> AnyPublisher<Trick, Error> {
        Publishers.MergeMany(ids.map { self.getTrickById($0.id) })
            .eraseToAnyPublisher()
    }
    
    func getTrickById(_ id: String) -> AnyPublisher<Trick, Error> {
        let firestore = Firestore.firestore()
        let publisher = PassthroughSubject<Trick, Error>()
        let documentReference = firestore.collection("tricksSR").document(id)
        documentReference.getDocument { (snapshot, error) in
            if error != nil {
                publisher.send(completion: .failure(NSError(domain: "Error", code: 0, userInfo: nil) as Error))
                print(error?.localizedDescription ?? "Some error")
            }
            
            guard let snapshot = snapshot else {
                publisher.send(completion: .failure(NSError(domain: "Error", code: 0, userInfo: nil) as Error))
                return
            }
            guard var data = snapshot.data() else {
                publisher.send(completion: .failure(NSError(domain: "Error", code: 0, userInfo: nil) as Error))
                return
            }
            data.removeValue(forKey: "prerequisites")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let trick = try JSONDecoder().decode(Trick.self, from: jsonData)
                publisher.send(trick)
            } catch {
                publisher.send(completion: .failure(error))
            }
        }
        return publisher.eraseToAnyPublisher()
    }

    func markTrickAsDone(ids: [String]) -> AnyPublisher<Bool, Error> {
        let publisher = PassthroughSubject<Bool, Error>()
        guard let user = Auth.auth().currentUser else {
            publisher.send(false)
            return publisher.eraseToAnyPublisher()
        }

        let firestore = Firestore.firestore()
        let data: [String: [String]] = ["SR": ids]
        firestore.collection("checklist").document(user.uid).setData(data) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                publisher.send(true)
                print("Document successfully written!")
            }
        }
        return publisher.eraseToAnyPublisher()
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
