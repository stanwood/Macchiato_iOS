//
//  Tests.swift
//  StanwoodUITesting_Tests
//
//  Created by Tal Zion on 11/06/2018.
//  Copyright © 2018 stanwood GmbH. All rights reserved.
//

import XCTest
import Macchiato

class StanwoodTests: XCTestCase {
    
    let app = XCUIApplication()
    var testingManager: Macchiato.Manager!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let slack = Macchiato.Slack(webhookURL: URL(string: "webhok")!, channelName: "channel")
        
        guard let path = Bundle(for: type(of: self)).url(forResource: "tests", withExtension: "json") else { XCTFail(); return }
        
        let configurations = Macchiato.Configurations(contentsOfFile: path, bundleIdentifier: "com.company.example", app: app, slack: slack)
        testingManager = Macchiato.Manager(configurations: configurations, target: self)
        testingManager.launch()
    }
    
    func testStanwood(){
        testingManager.runTests()
    }
}
