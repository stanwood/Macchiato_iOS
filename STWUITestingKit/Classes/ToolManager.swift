//
//  XCTestCase.swift
//  Glamour
//
//  Created by Tal Zion on 22/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation
import XCTest

public enum ToolError: Error {
    case error(String)
}

open class ToolManager {
    
    open static var shared: ToolManager = ToolManager()
    
    /*
     :executeTests: Bool // Default value is true
     */
    fileprivate var shouldExecutreTest:Bool = true
    
    fileprivate var testCases:[Schema] = []
    fileprivate var tool:TestTool?
    
    private init(){
    }
    
    open func setup(tool: TestTool) {
        self.tool = tool
        self.tool?.app.setupAndLaunch()
    }
    
    open func launch() {
        guard let tool = tool else {
            
            // Throwing config error
            Report.shared.test(failed: FailureItem(message: "Did not setup a testing tool item: Check - ToolItem"))
            return
        }
        
        /// MARK: - Fetching test cases
        
        shouldExecutreTest = false
        
        XCTHelper.fetchSchema(withUrl: tool.url, complition: {
            [weak self] testCases in
            guard let `self` = self else { return }
            
            // Setting up JSON Schema
            self.testCases.removeAll()
            self.testCases.append(contentsOf: testCases)
            
            DispatchQueue.main.async(execute: {
                self.dismissinLaunch(with: tool.launchHandlers)
                self.shouldExecutreTest = true
            })
        })
        
        while !shouldExecutreTest {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
        }
    }
    
    open func runTests() {
        guard let tool = tool else {
            
            // Throwing config error
            Report.shared.test(failed: FailureItem(message: "Did not setup a testing tool item: Check - ToolItem"))
            return
        }
        
        for schema in testCases {
            
            /// Navigation Items
            for navigation in schema.navigationItems {
                
                /// Navigate to...
                let passed = Navigator.navigate(to: navigation, query: nil, element: nil, app: tool.app)
                
                /// Cechk if test passed
                if !passed.pass {
                    Report.shared.test(failed: FailureItem(testID: schema.id ?? "", navigationID: navigation.sequence, message: passed.failiurMessage))
                }
                
                sleep(2)
            }
            
            
            /// Setting default view
            XCTHelper.navigateToDefault(app: tool.app)
        }
        
        /// Checking if tests passed
        if let report = Report.shared.print {
            XCTFail(report)
        }
    }
    
    fileprivate func dismissinLaunch(with handlers: [LaunchHandlers]) {
        
        guard let tool = tool else {
            
            // Throwing config error
            Report.shared.test(failed: FailureItem(message: "Did not setup a testing tool item: Check - ToolItem"))
            return
        }
        
        for handler in tool.launchHandlers {
            switch handler {
            case .notification:
                // Setting up nitifications
                XCTHelper.allowNotifications(withApp: tool.app)
                continue
            case .review:
                // Dismissing pop up alerts
                XCTHelper.dismissReviewAlert(withApp: tool.app)
                continue
            case .default:
                // Cloasing any open pop ups
                XCTHelper.close(withApp: tool.app)
                continue
            }
        }
    }
}
