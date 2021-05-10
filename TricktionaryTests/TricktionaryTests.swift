//
//  TricktionaryTests.swift
//  TricktionaryTests
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import XCTest
import Resolver
import Combine

class TricktionaryTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        Resolver.registerTrickListDependencies()
    }
    
    func testTrickList() {
        let vm = TricksViewModel()
        XCTAssert(vm.username == "Marek")
    }
    
    func testCheckListEmpty() {
        let vm = TricksViewModel()
        XCTAssert(vm.tricksManager.completedTricks.isEmpty)
    }
    
    func testCheckListNotEmpty() {
        Resolver.register {
            TricksContentManagerTestNotEmpty()
        }.implements(TricksContentManagerType.self)
        
        let vm = TricksViewModel()
        XCTAssert(vm.tricksManager.completedTricks.count == 2)
    }
}
