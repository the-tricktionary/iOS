//
//  TricktionaryTests.swift
//  TricktionaryTests
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import XCTest
@testable import Tricktionary

class TricktionaryTests: XCTestCase {
    
    var vm: TricksViewModelType!

    override func setUp() {
        vm = TricksViewModel(dataProvider: TestProvider())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        vm = nil
    }

    func testTricks() {
        vm.getTricks()
        XCTAssert(vm.trickList.value.parents.count == 0, "Bad parents count")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

class TestProvider: TricksDataProviderType {
    func getTricks(starting: @escaping () -> (), completion: @escaping ([String : Any]) -> Void, finish: @escaping () -> Void) {
        
    }
    
    
}
