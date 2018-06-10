//
//  Navigator.swift
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

extension UITesting {
    
    class Navigator {
        
        private let report: Report
        private let screenshots: Screenshots
        
        init(report: Report, screenshots: Screenshots) {
            self.report = report
            self.screenshots = screenshots
        }
        
        // MARK: - Navigation Actions
        
        fileprivate func action(withItem item: NavigationItem, element: XCUIElement?) -> (pass: Bool, failiurMessage: String) {
            switch item.action! {
            case .tap:
                /// MARK: Tap Action
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                
                if element.exists {
                    if element.isHittable {
                        element.tap()
                        return Passed
                    } else {
                        var test = Failed
                        test.1 = "Element is not hittable"
                        return test
                    }
                } else {
                    var test = Failed
                    test.1 = "Element *\(element.description)* does not exists"
                    return test
                }
            case .exists:
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                
                /// MARK: Exists Action
                
                if element.exists {
                    return Passed
                } else {
                    var test = Failed
                    test.1 = "Element *\(element.description)* does not exists"
                    return test
                }
            case .isHittable:
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                /// MARK: Is Hittable Action
                
                if element.isHittable {
                    return Passed
                } else {
                    var test = Failed
                    test.1 = "Element *\(element.description)* is not hittable"
                    return test
                }
                
                
                /// MARK: Swipe Actions
                
            case .swipeDown:
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                
                element.swipeDown()
                return Passed
            case .swipeLeft:
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                
                element.swipeLeft()
                return Passed
            case .swipeRight:
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                
                element.swipeRight()
                return Passed
            case .swipeUp:
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                
                element.swipeUp()
                return Passed
                
            // MARK: Screenshot
            case .screenshot:
                screenshots.takeSnapshot()
                return Passed
                
            case .type(let text):
                
                guard let element = element else {
                    var test = Failed
                    test.1 = "No element found"
                    return test
                }
                
                if element.exists {
                    if element.isHittable {
                        element.tap()
                        
                        sleep(1)
                        
                        element.typeText(text)
                        
                        sleep(1)
                        
                        // Resiging 
                        element.typeText("\n")
                        return Passed
                    } else {
                        var test = Failed
                        test.1 = "Element is not hittable"
                        return test
                    }
                } else {
                    var test = Failed
                    test.1 = "Element dowes not exists"
                    return test
                }
            }
        }
        
        // MARK: - Navigation
        
        func navigate(to item: NavigationItem, query: XCUIElementQuery?, element: XCUIElement?, app: XCUIApplication? = nil) -> (pass: Bool, failiurMessage: String) {
            
            //Cheking for valid type
            guard let type = item.type else {
                var failed = Failed
                failed.1 = "Invalid type"
                return failed
            }
            
            switch type {
            case .action:
                if item.action != nil {
                    return action(withItem: item, element: element)
                }
            case .buttons:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.buttons.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.buttons[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.buttons, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.buttons.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.buttons[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.buttons, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.buttons.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.buttons[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.buttons, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
                
            case .radioButtons:
                switch (app, query, element) {
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.radioButtons.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: query!.radioButtons[item.key])
                    }
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.radioButtons.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: app!.radioButtons[item.key])
                    }
                default:
                    report.test(failed: Failure(message: "XCTest Navigation failiur: Failed to fetach query or element: *radioButtons*"))
                }
                
            case .tabBars:
                
                // MARK: - tabBars
                
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.tabBars.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.tabBars[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.tabBars, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.tabBars.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.tabBars[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.tabBars, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.tabBars.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.tabBars[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.tabBars, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
                
            case .tables:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.tables.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.tables[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.tables, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.tables.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.tables[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.tables, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.tables.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.tables[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.tables, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
                
            case .tableRows:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.tableRows.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.tableRows[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.tableRows, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.tableRows.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.tableRows[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.tableRows, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.tableRows.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.tableRows[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.tableRows, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
                
            case .collectionViews:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.collectionViews.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.collectionViews[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.collectionViews, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.collectionViews.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.collectionViews[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.collectionViews, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.collectionViews.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.collectionViews[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.collectionViews, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .navigationBars:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.navigationBars.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.navigationBars[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.navigationBars, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.navigationBars.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.navigationBars[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.navigationBars, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.navigationBars.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.navigationBars[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.navigationBars, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .images:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.images.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.images[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.images, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.images.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.images[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.images, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.images.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.images[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.images, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .cells:
                
                // MARK: - cells
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.cells.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.cells[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.tabs, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.cells.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.cells[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.cells, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.cells.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.cells[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.cells, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .tabs:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.tabs.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.tabs[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.tabs, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.tabs.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.tabs[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.tabs, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.tabs.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.tabs[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.tabs, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .textFields:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.textFields.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.textFields[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.textFields, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.textFields.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.textFields[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.textFields, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.textFields.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.textFields[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.textFields, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .secureTextFields:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.secureTextFields.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.secureTextFields[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.secureTextFields, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.secureTextFields.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.secureTextFields[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.secureTextFields, element: nil)
                    }
                case (.none, .none, .some):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: element!.secureTextFields.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: element!.secureTextFields[key])
                    } else {
                        return navigate(to: item.successor!, query: element!.secureTextFields, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .alerts:
                switch (app, query, element) {
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.alerts.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: app!.alerts[key])
                    } else {
                        return navigate(to: item.successor!, query: app!.alerts, element: nil)
                    }
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.alerts.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.alerts[key])
                    } else {
                        return navigate(to: item.successor!, query: query!.alerts, element: nil)
                    }
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .checkBox:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .disclosureTriangle:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .popUpButton:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .popUpButtons:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .comboBox:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .menuButtons:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .toolbarButtons:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .popover:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .keyboard:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .key:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .pageIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .progressIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .tableColumns:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .outline:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .outlineRow:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .browser:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .activityIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .segmentedControl:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .tabGroups:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .toolBars:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .statusBar:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .picker:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .pickerWheel:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .`switch`:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .toggle:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .link:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .icons:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .searchField:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .searchFields:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .scrollViews:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .scrollBars:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .staticText:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .datePicker:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .textViews:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .menu:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .menuItems:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .menuBar:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .menuBarItem:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .map:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .webView:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .incrementArrow:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .decrementArrow:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .timeline:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .ratingIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .valueIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .splitGroup:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .splitter:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .relevanceIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .colorWell:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .helpTag:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .matte:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .dockItem:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .ruler:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .rulerMarker:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .grid:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .levelIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .layoutArea:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .layoutItems:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .handle:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .stepper:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .touchBars:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .any:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .other:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .application:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .group:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .windows:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .sheets:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .drawer:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .dialogs:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            }
            
            /// Default failure
            var failed = Failed
            failed.1 = "No navigation item handled for *\(type)*"
            return failed
        }
    }
}
