//
//  TricktionaryUITests.swift
//  TricktionaryUITests
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import XCTest
import SwiftMonkey

class TricktionaryUITests: XCTestCase {

    func testExample() {
        let app = XCUIApplication()
        app.launchArguments = ["--MonkeyPaws"]
        app.launch()
        let monkey = Monkey(frame: app.frame)
        monkey.addDefaultUIAutomationActions()
        monkey.monkeyAround()
    }

}
