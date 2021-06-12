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
import Combine

enum SpeedError: Error {
    case notLoggedIn
    case unkwnown(Error)
}

protocol SpeedTimerDataProviderType {
    func fetchEvents() -> AnyPublisher<[SpeedEvent], Error>
}

class SpeedManager: SpeedTimerDataProviderType {
    
    static var shared: SpeedManager {
        get {
            return SpeedManager()
        }
    }
    
    func fetchEvents() -> AnyPublisher<[SpeedEvent], Error> {
        let publisher = CurrentValueSubject<[SpeedEvent], Error>([])
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("speedEvents")
        
        documentReference.getDocuments { (snapshot, error) in
            if let error = error {
                publisher.send(completion: .failure(error))
            }
            
            guard let snapshot = snapshot else {
                publisher.send(completion: .failure(NSError(domain: "Speed events fetch error", code: 0, userInfo: nil)))
                return
            }
            
            let events = snapshot.documents.map { document -> SpeedEvent? in
                let data = document.data()
                let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
                let event = try? JSONDecoder().decode(SpeedEvent.self, from: jsonData ?? Data())
                return event
            }.compactMap { $0 }
            
            publisher.send(events)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    fileprivate let firestore = Firestore.firestore()
    
    func getSpeedData(starting: @escaping () -> Void, completion: @escaping (Speed) -> Void, finish: @escaping () -> Void) {
        starting()
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
                    speed.speedId = document.documentID
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
        var _ = firestore.collection("speed").document(speed.speedId).delete() { error in
            if let error = error {
                print("Deleting speed event error \(error.localizedDescription)")
            } else {
                completed()
                print("Deleting speed event \(speed.speedId) completed")
            }
        }
    }
}
