//
//  TrickList.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 31/12/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import Foundation

class TrickList {
    
    // MARK: Variables
    
    var Tree: [String : [String : [Parent]]] = ["Tree" : ["Parents" : []]]
    var parents: [Parent] = []
    var tricksForFiltering: [Trick] = []
    
    // MARK: Public
    
    func addTrick(data: [String : Any]) {
        let type = data["type"] as! String
        let name = data["name"] as! String
        let level = data["level"] as? Int
        if level == nil {
            print(data["name"] as! String)
        }
        let trick: Trick = Trick(data)
        tricksForFiltering.append(trick)
        addParent(id: level ?? 0)
        
        parents.forEach { (parent) in
            if parent.Id == level {
                parent.addChild(type: type)
                parent.child.forEach({ (child) in
                    if child.Id == type {
                        child.addSubChild(name)
                    }
                })
            }
        }
     }
    
    func getJSONData() -> Data {
        
        Tree["Tree"]!["Parents"] = parents.sorted(by: { (parent1, parent2) -> Bool in
            parent1.Id < parent2.Id
        })
        var data: Data?
        let encoder = JSONEncoder()
        do {
            data = try encoder.encode(Tree)
        } catch {
            print("ERROR: \(error)")
        }
        return data ?? Data()
    }
    
    // MARK: Private
    
    fileprivate func addParent(id: Int) {
        if id == 0 {
            return
        }
        
        let parent = parents.filter { (parent) -> Bool in
            return parent.Id == id
        }
        
        if parent.count == 0 {
            parents.append(Parent(id))
        }
    }
}

class Parent: Codable {
    
    // MARK: Variables
    
    var Id: Int
    var Expanded: Bool = true
    var child: [Childs]
    
    // MARK: Life cycles
    
    init(_ parentId: Int) {
        self.Id = parentId
        self.child = []
    }
    
    // MARK: Public
    
    func addChild(type: String) {
        
        var childs: Int = 0
        child.forEach { (child) in
            if child.Id == type {
                childs += 1
            }
        }
        if childs == 0 {
            child.append(Childs(type))
        }
    }
}

class Childs: Codable {
    
    // MARK: Varables
    
    var Id: String
    var Expanded: Bool = false
    var child: [Childs]
    
    // MARK: Life cycles
    
    init(_ id: String) {
        self.Id = id
        self.child = []
    }
    
    // MARK: Public
    
    func addSubChild(_ id: String) {
        child.append(Childs(id))
    }
}
