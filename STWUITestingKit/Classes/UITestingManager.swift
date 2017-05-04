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

open class UITestingManager {
    
    open static var shared: UITestingManager = UITestingManager()
    
    /*
     :executeTests: Bool // Default value is true
     */
    fileprivate var shouldExecutreTest:Bool = true
    
    fileprivate var testCases:[STWSchema] = []
    fileprivate var tool:STWTestConfigurations?
    
    private init(){
    }
    
    open func setup(tool: STWTestConfigurations) {
        self.tool = tool
        self.tool?.app.setupAndLaunch()
    }
    
    open func launch() {
        guard let tool = tool else {
            
            // Throwing config error
            STWReport.shared.test(failed: STWFailure(message: "Did not setup a testing tool item: Check - ToolItem"))
            return
        }
        
        /// MARK: - Fetching test cases
        
        shouldExecutreTest = false
        
        XCTHelper.fetchSTWSchema(withUrl: tool.url, complition: {
            [weak self] testCases in
            guard let `self` = self else { return }
            
            // Setting up JSON STWSchema
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
            STWReport.shared.test(failed: STWFailure(message: "Did not setup a testing tool item: Check - ToolItem"))
            return
        }
        
        for STWSchema in testCases {
            
            /// Navigation Items
            for navigation in STWSchema.STWNavigationItems {
                
                /// Navigate to...
                let passed = STWNavigator.navigate(to: navigation, query: nil, element: nil, app: tool.app)
                
                /// Cechk if test passed
                if !passed.pass {
                    STWReport.shared.test(failed: STWFailure(testID: STWSchema.id ?? "", navigationID: navigation.sequence, message: passed.failiurMessage))
                }
                
                sleep(2)
            }
            
            
            /// Setting default view
            XCTHelper.navigateToDefault(app: tool.app)
        }
        
        /// Checking if tests passed
        if let STWReport = STWReport.shared.print {
            print(STWReport)
            XCTFail(STWReport)
        }
    }
    
    fileprivate func dismissinLaunch(with handlers: [LaunchHandlers]) {
        
        guard let tool = tool else {
            
            // Throwing config error
            STWReport.shared.test(failed: STWFailure(message: "Did not setup a testing tool item: Check - ToolItem"))
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
