//
//  STWSchemaTests.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 04/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import STWUITestingKit

class STWSchemaTests: XCTestCase {
    
    let app = XCUIApplication()
    var currentToken: NSObjectProtocol?
    var testingManager: UITesting.Manager!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let baseURLString: String = "https://stanwood-ui-testing.firebaseio.com"
        let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)?.replacingOccurrences(of: ".", with: "-") ?? "-"
        guard let url = URL(string: "ios/com-uitesting-example/\(version).json", relativeTo: URL(string: baseURLString)) else { return }
        let launchHandlers: [LaunchHandlers] = [.notification, .review, .default]
        
        let slack = UITesting.Slack(teamID: "T034UPBQE", channelToken: "B8K8L6S1Y/F6SKtmB1GoAbcDaTl00fuxtx", channelName: "#_ui_testing")
        let tool = UITesting.Configurations(url: url, launchHandlers: launchHandlers, app: app, slack: slack)
        
        testingManager = UITesting.Manager(tool: tool)
        testingManager.launch()
        
        monitor()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSTWSchema(){
        testingManager.runTests { [unowned self] in
            if let token = self.currentToken {
                self.removeUIInterruptionMonitor(token)
            }
            
            self.monitor()
        }
    }
    
    // Monitoring for system alerts
    func monitor(){
        self.currentToken = addUIInterruptionMonitor(withDescription: "Authorization Prompt") {
            
            if $0.buttons["Allow"].exists {
                $0.buttons["Allow"].tap()
            }
            
            if $0.buttons["OK"].exists {
                $0.buttons["OK"].tap()
            }
            
            return true
        }
    }
}
