//
//  STWSchemaTests.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 04/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import StanwoodUITesting

class StanwoodTests: XCTestCase {
    
    let app = XCUIApplication()
    var testingManager: UITesting.Manager!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
  
        let slack = UITesting.Slack(webhookURL: URL(string: "https://hooks.slack.com/services/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")!, channelName: "#testing_notifiy")
        guard let configurations = UITesting.Configurations(bundleId: "com.uitesting.example", version: "1.0", app: app, slack: slack) else { return }
        
        testingManager = UITesting.Manager(configurations: configurations, target: self)
        testingManager.launch()
    }
    
    func testStanwood(){
        testingManager.runTests()
    }
    
    func testG() {
        XCUIApplication().navigationBars["STWUITestingKit_Example.TabView"].buttons["Test"].tap()
        
    }
}
