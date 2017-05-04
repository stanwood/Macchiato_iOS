//
//  SchemaTests.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 04/05/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import STWUITestingKit

class SchemaTests: XCTestCase {
    
    let app = XCUIApplication()
    
    /// Based on JSONSchema draft4 tempalte
    let url = "https://dl.dropboxusercontent.com/s/qbfgngc7bzuq3s5/test_chema.json"
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        guard let url = URL(string: url) else { return }
        let launchHandlers: [LaunchHandlers] = [.notification, .review, .default]
        
        let tool = TestTool(url: url, launchHandlers: launchHandlers, app: app)
        
        ToolManager.shared.setup(tool: tool)
        
        ToolManager.shared.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSchema(){
        ToolManager.shared.runTests()
    }
    
}
