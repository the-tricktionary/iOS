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
    
    // MARK: Variables
    
    var trickList: MutableProperty<TrickList> = MutableProperty<TrickList>(TrickList())
    var filteredTricks: [Trick] = [Trick]()
    
    // MARK: Publics
    
    func getTricks(starting: @escaping () -> (), finish: @escaping () -> ()) {
        
        TrickManager.shared.getTricks(starting: {
            starting()
        }, completion: { (data) in
            self.trickList.value.addTrick(data: data)
        }) {
            finish()
        }
    }
    
    func getArrayOfParrents() -> NSArray? {
        let parents = trickList.value.getJSONData()
        var jsonDictionary: NSDictionary?
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: parents, options: .init(rawValue: 0)) as? NSDictionary
        }catch{
            print("error")
        }
        
        var arrayParents: NSArray?
        if let treeDictionary = jsonDictionary?.object(forKey: "Tree") as? NSDictionary {
            if let arrayOfParents = treeDictionary.object(forKey: "Parents") as? NSArray {
                arrayParents = arrayOfParents
            }
        }
        return arrayParents
    }
    
}
