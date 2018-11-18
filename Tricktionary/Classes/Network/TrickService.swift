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
import RxFirestoreExecutor
import RxSwift

//enum TrickService {
//
//    case listData()
//}
//
//extension TrickService: QueryTargetProtocol {
//
//    //Only  collection is not optional.
//
//    var collection: CollectionRef {
//        switch self {
//        case .listData():
//            return "tricksSR"
//        }
//    }
//
//    var singleDocument: SingleDocument {
//        switch self {
//        case .listData():
//            return ""
//        }
//    }
//
//    // everything else should return nil if not used.
//
//    var params: TraitList {
//        return nil
//    }
//
//    var data: UpdateableData {
//        return (nil, nil)
//    }
//
//    var nestedCollection: NestedCollection {
//        return nil
//    }
//
//    var orPair: ConditionPair {
//        return nil
//    }
//
//    var order: OrderTrait {
//        return nil
//    }
//}

class TrickService {

    // MARK: Variables

//    var tricks: [Trick] = [Trick]()

//    let firestore: Firestore = Firestore.firestore()

    // MARK: Life cycles

    // MARK: Public

    func getTricksByLevel(level: Int, tricks: inout MutableProperty<[Trick]>) {
        let firestore = Firestore.firestore()
        let documentReference = firestore.collection("tricksSR").whereField("level", isEqualTo: level)
        documentReference.getDocuments { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Some error")
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
                    tricks.value.append(trick)
                } catch {
                    print(error.localizedDescription)
                }
            })
        }
    }
}
