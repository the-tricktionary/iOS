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

protocol TricksViewModelType {
    var trickList: MutableProperty<TrickList> { get }
    var tricks: MutableProperty<[Trick]> { get }
    var filteredTricks: [Trick] { get }
    var selectedLevel: Int { get set }
    
    func getTricks()
}

class TricksViewModel: TricksViewModelType {
    
    // MARK: Variables
    
    var trickList: MutableProperty<TrickList> = MutableProperty<TrickList>(TrickList())
    var tricks: MutableProperty<[Trick]> = MutableProperty<[Trick]>([Trick]())
    var filteredTricks: [Trick] = [Trick]()
    
    var selectedLevel: Int = 1
    
    var onStartLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    
    private let dataProvider: TricksDataProviderType
    
    // MARK: Initializer
    
    init(dataProvider: TricksDataProviderType) {
        self.dataProvider = dataProvider
    }
    
    // MARK: Publics
    
    func getTricks() {
        
        dataProvider.getTricks(starting: { [weak self] in
            self?.onStartLoading?()
        }, completion: { [weak self] (data) in
            self?.trickList.value.addTrick(data: data)
            self?.tricks.value.append(Trick(data))
        }) { [weak self] in
            self?.onFinishLoading?()
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
    
    func getTrickTypes() -> [String] {
        let levelTricks = tricks.value.filter { $0.level == self.selectedLevel }
        var types = Set<String>()
        levelTricks.forEach { (trick) in
            types.insert(trick.type)
        }
        
        return Array(types).sorted(by: { (trick1, trick2) -> Bool in
            trick1 < trick2
        })
    }
    
    func getTricks(_ type: String) -> [Trick] {
        return tricks.value.filter {
            $0.level == self.selectedLevel && $0.type == type
        }
    }
}
