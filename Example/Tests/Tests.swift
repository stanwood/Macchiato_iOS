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
        
        let testsUrl: URL? = URL(string: "https://stanwood-ui-testing.firebaseio.com/com-company-example/1-0.json")
        
        guard let configurations = UITesting.Configurations(testsUrl: testsUrl, bundleIdentifier: "com.company.example", app: app, slack: slack) else { XCTFail(); return }
        
        testingManager = UITesting.Manager(configurations: configurations, target: self)
        testingManager.launch()
    }
    
    func testStanwood(){
        testingManager.runTests()
    }
}
