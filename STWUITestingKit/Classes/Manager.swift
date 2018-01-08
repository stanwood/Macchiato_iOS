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
        private var shouldExecuteTest:Bool = true
        private var testCases: [TestCase] = []
        private var currentToken: NSObjectProtocol?
        
        private weak var target: XCTestCase?
        
        private let configurations: Configurations
        private let report: Report
        private let navigator: Navigator
        private let screenshots: Screenshots
        
        public init(configurations: Configurations, target: XCTestCase) {
            self.target = target
            self.configurations = configurations
            self.configurations.app.setupAndLaunch()
            
            self.report = Report(bundleId: configurations.bundleIdentifier)
            self.screenshots = Screenshots(app: configurations.app)
            self.navigator = Navigator(report: report, screenshots: screenshots)
        }
        
        ///
        /// Launch testing tool and fetch test cases
        ///
        open func launch() {
    
            /// MARK: - Fetching test cases
            
            shouldExecuteTest = false
            
            Helper.fetchTestCases(withUrl: configurations.url, report: report, completion: {
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
            
            // Monitor system alerts on launch
            monitor()
            
            while !shouldExecuteTest {
                RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
            }
        }
        
        ///
        /// Run tests
        ///
        open func runTests() {
            
            for testCase in testCases {
                
                /// Navigation Items
                for navigation in testCase.navigationItems {
                    
                    /// Navigate to...
                    let test = navigator.navigate(to: navigation, query: nil, element: nil, app: configurations.app)
                    
                    /// Required for triggering alerts monitoring.
                    if navigation.shouldMonitor {
                        configurations.app.tap()
                    }
                    
                    /// Check if test passed
                    if !test.pass {
                        report.test(failed: Failure(testID: testCase.id ?? "", navigationID: navigation.sequence, message: test.failiurMessage))
                    }
                    
                    sleep(2)
                }
                
            
                /// Setting default view
                Helper.navigateToDefault(app: configurations.app)
            }
            
            /// Finishing with the tests and posting the report
            finalise()
        }
        
        /// Monitoring system alerts
        private func monitor() {
            // Monitoring for system alerts
            
            sleep(1)
            
            self.currentToken = target?.addUIInterruptionMonitor(withDescription: "permission") {
                
                if $0.alerts.buttons.element(boundBy: 0).exists {
                   $0.alerts.buttons.element(boundBy: 0).tap()
                    
                    return true
                }
                return false
            }
        }
        
        /// Finalise tests
        private func finalise() {
            
            shouldExecuteTest = false
            
            /// Saving screenshots to file
            do {
                try screenshots.save()
            } catch UITesting.TestError.error(let error) {
                report.test(failed: UITesting.Failure(message: "System error saving screenshots to file: \(error.message)"))
            } catch {
                print(error)
            }
            
            /// Posting report
            configurations.slack?.post(report: report) { [unowned self] in
                
                /// Checking if tests passed
                if !self.report.didPass {
                    /// Failing the test
                    XCTFail(self.report.review)
                }
                
                self.shouldExecuteTest = true
            }
            
            while !shouldExecuteTest {
                sleep(1)
            }
        }
        
        // MARK: - Dismiss system alerts
        
        private func dismissinLaunch(with handlers: [LaunchHandlers]) {
            // Cloasing any open pop ups
            Helper.close(withApp: configurations.app)
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

