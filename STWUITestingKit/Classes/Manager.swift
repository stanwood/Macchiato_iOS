//
//  XCTestCase.swift
//  UITesting
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

public struct UITesting {}

extension UITesting {
    
    open class Manager {
        
        /*
         :executeTests: Bool // Default value is true
         */
        fileprivate var shouldExecuteTest:Bool = true
        
        fileprivate var testCases: [TestCase] = []
        fileprivate var configurations: Configurations
        private var report: Report
        private let navigator: Navigator
        
        public init(tool: Configurations) {
            self.configurations = tool
            self.configurations.app.setupAndLaunch()
            
            self.report = Report()
            self.navigator = Navigator(report: report)
        }
        
        open func launch() {
            
            /// MARK: - Fetching test cases
            
            shouldExecuteTest = false
            
            Helper.fetchSTWSchema(withUrl: configurations.url, report: report, complition: {
                [weak self] testCases in
                guard let `self` = self else { return }
                
                // Setting up JSON STWSchema
                self.testCases.removeAll()
                self.testCases.append(contentsOf: testCases)
                
                if self.testCases.count == 0 {
                    self.report.test(failed: Failure(message: "No test cases"))
                }
                
                DispatchQueue.main.async(execute: { [unowned self] in
                    self.dismissinLaunch(with: self.configurations.launchHandlers)
                    self.shouldExecuteTest = true
                })
            })
            
            // Setting device local
            setLanguage(configurations.app)
            setLocale(configurations.app)
            
            while !shouldExecuteTest {
                RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
            }
        }
        
        open func runTests(target: XCTestCase) {
            
            for STWSchema in testCases {
                
                /// Navigation Items
                for navigation in STWSchema.navigationItems {
                    
                    /// Adding navigation monitor
                    if navigation.shouldMonitor {
                        
                        /// Monitoring for system alerts
                        
                        monitor()
                    }
                    
                    /// Navigate to...
                    let test = navigator.navigate(to: navigation, query: nil, element: nil, app: configurations.app)
                    
                    /// Cechk if test passed
                    if !test.pass {
                        report.test(failed: Failure(testID: STWSchema.id ?? "", navigationID: navigation.sequence, message: test.failiurMessage))
                    }
                    
                    sleep(2)
                }
                
                
                /// Setting default view
                Helper.navigateToDefault(app: configurations.app)
            }
            
            /// Finishing with the tests and posting the report
            finalise()
        }
        
        fileprivate func finalise() {
            
            shouldExecuteTest = false
            
            /// Posting report
            configurations.slack?.post(report: report) { [unowned self] in
                
                /// Checking if tests passed
                if !self.report.didPass {
                    /// Failing the test
                    XCTFail(self.report.print)
                }
                
                self.shouldExecuteTest = true
            }
            
            while !shouldExecuteTest {
                sleep(1)
            }
        }
        
        // MARK: - Dismiss system alerts
        
        fileprivate func dismissinLaunch(with handlers: [LaunchHandlers]) {
            
            for handler in configurations.launchHandlers {
                switch handler {
                case .notification:
                    // Setting up nitifications
                    Helper.allowNotifications(withApp: configurations.app)
                    continue
                case .review:
                    // Dismissing pop up alerts
                    Helper.dismissReviewAlert(withApp: configurations.app)
                    continue
                case .default:
                    // Cloasing any open pop ups
                    Helper.close(withApp: configurations.app)
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
}

