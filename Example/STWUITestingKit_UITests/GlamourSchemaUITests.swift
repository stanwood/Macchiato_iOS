//
//  GlamourSchemaUITests.swift
//  Glamour
//
//  Created by Tal Zion on 21/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import XCTest
import STWUITestingKit

class GlamourSchemaUITests: XCTestCase {
    
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
    
    // MARK: JSON Scheme TestCase Test
    
    func testSchema(){
        ToolManager.shared.runTests()
    }
    
    func scheme(){
        
        //let error = testCases[0].validate(["name":"Boots"])
        //print(error)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        let seaarchElement = app.searchFields.element(boundBy: 1)
        XCTAssertTrue(seaarchElement.exists)
        let element = app.tables.cells.staticTexts.matching(identifier: "ABOUT YOU")
        XCTAssertTrue(element.element.exists)
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element
        XCTAssertTrue(element2.exists)
        XCTAssertEqual(app.tables.cells.count, 7)
        
        app.tables.cells.containing(.staticText, identifier:"ABOUT YOU").element.swipeUp()
        app.tables.cells.containing(.staticText, identifier:"ABOUT YOU").element.swipeUp()
        app.tables.cells.containing(.staticText, identifier:"ABOUT YOU").element.swipeUp()
    }
}
