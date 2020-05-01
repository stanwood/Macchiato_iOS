//
//  XCTestCase.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Stanwood GmbH (www.stanwood.io)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import XCTest

var deviceLanguage = "en-GB"
var locale = ""

// Monitor Block
public typealias MonitorBlock = ()-> Void

public enum ToolError: Error {
    case error(String)
}

public struct Macchiato {}

extension Macchiato {
    
    open class Manager {
        
        /*
         :executeTests: Bool // Default value is true
         */
        private var shouldExecuteTest:Bool = true
        private var testCases: TestCases?
        private var currentToken: NSObjectProtocol?
        
        private weak var target: XCTestCase?
        
        private let configurations: Configurations
        private let report: Report
        private let navigator: Navigator
        private let screenshots: Screenshots
        private let loadingHelper: Macchiato.LoadingHelper
        
        public init(configurations: Configurations, target: XCTestCase) {
            self.target = target
            self.configurations = configurations
            self.configurations.app.setupAndLaunch()
            self.loadingHelper = LoadingHelper(app: configurations.app)
            self.report = Report(bundleId: configurations.bundleIdentifier)
            self.screenshots = Screenshots(app: configurations.app, loadingHelper: loadingHelper)
            self.navigator = Navigator(report: report, screenshots: screenshots, loadingHelper: loadingHelper)
        }
        
        ///
        /// Launch testing tool and fetch test cases
        ///
        open func launch() {
    
            /// MARK: - Fetching test cases
            
            shouldExecuteTest = false
            
            /// Load test cases
            load()
            
            // Setting device local
            setLanguage(configurations.app)
            setLocale(configurations.app)
            
            // Monitor system alerts on launch
            monitor()
            
            while !shouldExecuteTest {
                RunLoop.current.run(mode: .default, before: .distantFuture)
            }
        }
        
        private func load() {
            if let url = configurations.url {
                Helper.fetchElement(withUrl: url, report: report) {
                    [weak self] (testCases: TestCases?) in
                    guard let `self` = self else { return }
                    
                    // Setting up JSON STWSchema
                    self.testCases = testCases
                    
                    if testCases == nil || self.testCases?.numberOfItems == 0 {
                        self.report.test(failed: Failure(message: "No test cases"))
                    }
                    
                    DispatchQueue.main.async(execute: { [unowned self] in
                        self.dismiss()
                        self.shouldExecuteTest = true
                    })
                }
            } else if let filePath = configurations.filePath {
                Helper.loadElement(fromFile: filePath, report: report) {
                    [weak self] (testCases: TestCases?) in
                    guard let `self` = self else { return }
                    
                    // Setting up JSON STWSchema
                    self.testCases = testCases
                    
                    if testCases == nil || self.testCases?.numberOfItems == 0 {
                        self.report.test(failed: Failure(message: "No test cases"))
                    }
                    
                    DispatchQueue.main.async(execute: { [unowned self] in
                        self.dismiss()
                        self.shouldExecuteTest = true
                    })
                }
            }
        }
        
        ///
        /// Run tests
        ///
        open func runTests() {
            guard let testCases = testCases else {
                report.test(failed: Macchiato.Failure(message: "No test cases. Please check you test case schema for issues!"))
                finalise()
                return
            }
            
            /// Sleep at initial start
            if let initialSleep = testCases.initialSleepTime {
                sleep(initialSleep)
            }
            
            for testCase in testCases.items {
                
                /// Navigation Items
                testCase.navigationItems.forEach({ (navigation) in
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
                })
              
                
                /// Taking screenshots is auto enabled
                if testCases.isAutoScreenshots! {
                    screenshots.takeSnapshot()
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

                if $0.buttons.element(boundBy: 1).exists {
                   $0.buttons.element(boundBy: 1).tap()
                }
                return true
            }
        }
        
        /// Finalise tests
        private func finalise() {
            
            shouldExecuteTest = false
            
            /// Saving screenshots to file
            do {
                try screenshots.save(shouldClearPreviousScreenshots: testCases?.shouldClearPreviousScreenshots ?? false)
            } catch Macchiato.TestError.error(let error) {
                report.test(failed: Macchiato.Failure(message: "System error saving screenshots to file: \(error.message)"))
            } catch {
                print(error)
            }
            
            /// Posting report
            if let slack = configurations.slack {
                slack.post(report: report) { [unowned self] in
                    self.complete()
                }
            } else {
                complete()
            }
            
            while !shouldExecuteTest {
                sleep(1)
            }
        }
        
        private func complete() {
            /// Checking if tests passed
            if !self.report.didPass {
                /// Failing the test
                XCTFail(self.report.review)
            }
            
            self.shouldExecuteTest = true
        }
        
        // MARK: - Dismiss system alerts
        
        private func dismiss() {
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

