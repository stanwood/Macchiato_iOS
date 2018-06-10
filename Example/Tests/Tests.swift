//
//  Tests.swift
//  StanwoodUITesting_Tests
//
//  Created by Tal Zion on 11/06/2018.
//  Copyright © 2018 stanwood GmbH. All rights reserved.
//

import XCTest
import StanwoodUITesting

class StanwoodTests: XCTestCase {
    
    let app = XCUIApplication()
    var testingManager: UITesting.Manager!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let slack = UITesting.Slack(webhookURL: URL(string: "webhok")!, channelName: "channel")
        guard let configurations = UITesting.Configurations(bundleId: "com.company.example", version: "1.0", app: app, slack: slack) else { return }
        
        testingManager = UITesting.Manager(configurations: configurations, target: self)
        testingManager.launch()
    }
    
    func testStanwood(){
        testingManager.runTests()
    }
}
