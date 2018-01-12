//
//  Navigator.swift
//  UITesting
//
//  Created by Tal Zion on 01/05/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

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
            case .button:
                switch (app, query, element) {
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: query![item.key])
                    }
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.buttons.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: app!.buttons[item.key])
                    }
                default:
                    report.test(failed: Failure(message: "XCTest Navigation failiur: Failed to fetach query or element"))
                    break
                }
            case .buttons:
                switch (app, query, element) {
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.buttons.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: query!.buttons[item.key])
                    }
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.buttons.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: app!.buttons[item.key])
                    }
                default:
                    report.test(failed: Failure(message: "XCTest Navigation failiur: Failed to fetach query or element"))
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
                    // TODO:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                case (.none, .none, .some):
                    // TODO:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
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
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
                
            case .images:
                switch (app, query, element) {
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.images.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: query!.images[item.key])
                    }
                case (.some, .none, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: app!.images.element(boundBy: UInt(index)))
                    } else {
                        return navigate(to: item.successor!, query: nil, element: app!.images[item.key])
                    }
                default:
                    report.test(failed: Failure(message: "XCTest Navigation failiur: Failed to fetach query or element"))
                }
                break
            case .cells:
                
                // MARK: - cells
                switch (app, query, element) {
                case (.some, .none, .none):
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                case (.none, .some, .none):
                    if let index = item.index {
                        return navigate(to: item.successor!, query: nil, element: query!.cells.element(boundBy: UInt(index)))
                    } else if let key = item.key {
                        return navigate(to: item.successor!, query: nil, element: query!.cells[key])
                    } else {
                        report.test(failed: Failure(message: "*.cells* have no key or an index"))
                    }
                case (.none, .none, .some):
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
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
                default:
                    report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                    break
                }
            case .icon:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .radioGroup:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
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
                
            case .menuButton:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .menuButtons:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .toolbarButton:
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
                
            case .navigationBar:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .pageIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .progressIndicator:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .tableColumn:
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
            case .tabGroup:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .tabGroups:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .toolbar:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .toolBars:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .statusBar:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .table:
                report.test(failed: Failure(message: "*table* has been removed from XCTest, please use *tables*"))
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
                
            case .scrollView:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .scrollViews:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .scrollBar:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .scrollBars:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .staticText:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .textField:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .textFields:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .secureTextField:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .secureTextFields:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .datePicker:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .textView:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .textViews:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .menu:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .menuItem:
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
                
            case .cell:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .layoutArea:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            case .layoutItem:
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
            case .touchBar:
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
                
            case .window:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .windows:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .sheet:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .sheets:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .drawer:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .alert:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .alerts:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .dialog:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
                
            case .dialogs:
                report.test(failed: Failure(message: "Incomplete Implementation. Please file for a feature request to add *\(type)* to StanwoodUITesting"))
                break
            }
            
            /// Default failure
            var failed = Failed
            failed.1 = "No navigation item handled"
            return failed
        }
    }
}
