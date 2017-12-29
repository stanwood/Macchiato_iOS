//
//  STWSchemaTests.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 04/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import STWUITestingKit

class StanwoodTests: XCTestCase {
    
    let app = XCUIApplication()
    var testingManager: UITesting.Manager!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let launchHandlers: [LaunchHandlers] = [.notification, .review, .default]
        let slack = UITesting.Slack(teamID: "T034UPBQE", channelToken: "B8K8L6S1Y/F6SKtmB1GoAbcDaTl00fuxtx", channelName: "#_ui_testing")
        guard let tool = UITesting.Configurations(bundleId: "com-uitesting-example", version: "1.0", launchHandlers: launchHandlers, app: app, slack: slack) else { return }
        
        testingManager = UITesting.Manager(tool: tool, target: self)
        testingManager.launch()
    }
    
    func testStanwood(){
        testingManager.runTests()
    }
}
