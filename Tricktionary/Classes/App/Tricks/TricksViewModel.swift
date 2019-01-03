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
    
    var isLoaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    var trickList: MutableProperty<TrickList> = MutableProperty<TrickList>(TrickList())
    
    // MARK: Publics
    
    func getTricks() {
        TrickService().getTricksByLevel(completion: { (data) in
            self.trickList.value.addTrick(data: data)
        }) {
            self.isLoaded.value = true
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
