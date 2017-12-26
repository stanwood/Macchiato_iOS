//
//  XCTestCase.swift
//  Glamour
//
//  Created by Tal Zion on 22/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation
import XCTest

var deviceLanguage = "en-GB"
var locale = ""

// Monitor Block
public typealias MonitorBlock = ()-> Void

public enum ToolError: Error {
    case error(String)
}

open class UITestingManager {
    
    /*
     :executeTests: Bool // Default value is true
     */
    fileprivate var shouldExecutreTest:Bool = true
    
    fileprivate var testCases: [STWSchema] = []
    fileprivate var configurations: STWTestConfigurations
    private var report: STWReport
    private let navigator: STWNavigator
    
    public init(tool: STWTestConfigurations) {
        self.configurations = tool
        self.configurations.app.setupAndLaunch()
        
        self.report = STWReport()
        self.navigator = STWNavigator(report: report)
    }
    
    open func launch() {

        /// MARK: - Fetching test cases
        
        shouldExecutreTest = false
        
        XCTHelper.fetchSTWSchema(withUrl: configurations.url, report: report, complition: {
            [weak self] testCases in
            guard let `self` = self else { return }
            
            // Setting up JSON STWSchema
            self.testCases.removeAll()
            self.testCases.append(contentsOf: testCases)
            
            if self.testCases.count == 0 {
                self.report.test(failed: STWFailure(message: "No test cases"))
            }
            
            DispatchQueue.main.async(execute: { [unowned self] in
                self.dismissinLaunch(with: self.configurations.launchHandlers)
                self.shouldExecutreTest = true
            })
        })
        
        // Setting device local
        setLanguage(configurations.app)
        setLocale(configurations.app)
        
        while !shouldExecutreTest {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
        }
    }
    
    open func runTests(monitor: MonitorBlock) {
        
        for STWSchema in testCases {
            
            /// Navigation Items
            for navigation in STWSchema.STWNavigationItems {
                
                /// Adding navigation monitor
                if navigation.shouldMonitor {
                    
                    /// Monitoring for system alerts
                  
                    monitor()
                }
                
                /// Navigate to...
                let test = navigator.navigate(to: navigation, query: nil, element: nil, app: configurations.app)
                
                /// Cechk if test passed
                if !test.pass {
                    report.test(failed: STWFailure(testID: STWSchema.id ?? "", navigationID: navigation.sequence, message: test.failiurMessage))
                }
                
                sleep(2)
            }
            
            
            /// Setting default view
            XCTHelper.navigateToDefault(app: configurations.app)
        }
        
        /// Checking if tests passed
        print(report.print)
        
        if !report.didPass {
            /// Posting report
            configurations.slack?.post(report: report)
            
            /// Failing the test
            XCTFail(report.print)
        }
    }
    
    // MARK: - Dismiss system alerts
    
    fileprivate func dismissinLaunch(with handlers: [LaunchHandlers]) {
        
        for handler in configurations.launchHandlers {
            switch handler {
            case .notification:
                // Setting up nitifications
                XCTHelper.allowNotifications(withApp: configurations.app)
                continue
            case .review:
                // Dismissing pop up alerts
                XCTHelper.dismissReviewAlert(withApp: configurations.app)
                continue
            case .default:
                // Cloasing any open pop ups
                XCTHelper.close(withApp: configurations.app)
                continue
            }
        }
    }
    
    // MARK: - Setting device local and language
    
    private func setLanguage(_ app: XCUIApplication) {
        app.launchArguments += ["-AppleLanguages", "(\(deviceLanguage))"]
    }
    
    private func setLocale(_ app: XCUIApplication) {
        if locale.isEmpty {
            locale = Locale(identifier: deviceLanguage).identifier
        }
        app.launchArguments += ["-AppleLocale", "\"\(locale)\""]
    }

}
