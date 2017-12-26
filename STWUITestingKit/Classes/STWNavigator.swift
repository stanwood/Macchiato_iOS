//
//  Navigator.swift
//  Glamour
//
//  Created by Tal Zion on 01/05/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation
import XCTest

class STWNavigator {
    
    private let report: STWReport
    
    init(report: STWReport) {
        self.report = report
    }
    
    // MARK: - Navigation Actions
    
    fileprivate func action(withItem item: STWNavigationItem, element: XCUIElement) -> (pass: Bool, failiurMessage: String) {
        switch item.action! {
        case .tap:
            /// MARK: Tap Action
            
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
                test.1 = "Element does not exists"
                return test
            }
        case .exists:
            /// MARK: Exists Action
            
            if element.exists {
                return Passed
            } else {
                var test = Failed
                test.1 = "Element does not exists"
                return test
            }
        case .isHittable:
            /// MARK: Is Hittable Action
            
            if element.isHittable {
                return Passed
            } else {
                var test = Failed
                test.1 = "Element is not hittable"
                return test
            }
            
            
            /// MARK: Swipe Actions
            
        case .swipeDown:
            element.swipeDown()
            return Passed
        case .swipeLeft:
            element.swipeLeft()
            return Passed
        case .swipeRight:
            element.swipeRight()
            return Passed
        case .swipeUp:
            element.swipeUp()
            return Passed
        }
    }
    
    // MARK: - Navigation
    
    func navigate(to item: STWNavigationItem, query: XCUIElementQuery?, element: XCUIElement?,app:XCUIApplication? = nil) -> (pass: Bool, failiurMessage: String) {
        
        //Cheking for valid type
        guard let type = item.type else {
            var failed = Failed
            failed.1 = "Invalid type"
            return failed
        }
        
        switch type {
        case .action:
            if let _ = item.action, let _ = element {
                return action(withItem: item, element: element!)
            }
        case .any:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .other:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .application:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .group:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .window:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .windows:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .sheet:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .sheets:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .drawer:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .alert:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .alerts:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .dialog:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .dialogs:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
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
                report.test(failed: STWFailure(message: "XCTest Navigation failiur: Failed to fetach query or element"))
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
                report.test(failed: STWFailure(message: "XCTest Navigation failiur: Failed to fetach query or element"))
            }
            
        case .radioButton:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .radioButtons:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .radioGroup:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .checkBox:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .disclosureTriangle:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .popUpButton:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .popUpButtons:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .comboBox:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuButton:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuButtons:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolbarButton:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolbarButtons:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .popover:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .keyboard:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .key:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .navigationBar:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabBar:
            
            // MARK: - tabBar
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabBars:
            
            // MARK: - tabBars
            
            switch (app, query, element) {
            case (.some, .none, .none):
                return navigate(to: item.successor!, query: app!.tabBars, element: nil)
            case (.none, .some, .none):
                // TODO:
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            case (.none, .none, .some):
                // TODO:
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            default:
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            }
        case .tabGroup:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabGroups:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolbar:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolBars:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .statusBar:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .table:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tables:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableRow:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableRows:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableColumn:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableColumns:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .outline:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .outlineRow:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .browser:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .collectionView:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .collectionViews:
            
            // TODO:
            switch (app, query, element) {
            case (.some, .none, .none):
                return navigate(to: item.successor!, query: app!.collectionViews, element: nil)
            case (.none, .some, .none):
                // TODO:
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            case (.none, .none, .some):
                // TODO:
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            default:
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            }
        case .slider:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .pageIndicator:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .progressIndicator:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .activityIndicator:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .segmentedControl:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .picker:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .pickerWheel:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
        case .`switch`:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toggle:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .link:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .image:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .images:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .icon:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .icons:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .searchField:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .searchFields:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollView:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollViews:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollBar:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollBars:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .staticText:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textField:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textFields:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .secureTextField:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .secureTextFields:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .datePicker:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textView:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textViews:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menu:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuItem:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuItems:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuBar:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuBarItem:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .map:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .webView:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .incrementArrow:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .decrementArrow:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .timeline:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .ratingIndicator:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .valueIndicator:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .splitGroup:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .splitter:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .relevanceIndicator:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .colorWell:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .helpTag:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .matte:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .dockItem:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .ruler:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .rulerMarker:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .grid:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .levelIndicator:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .cell:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .cells:
            
            // MARK: - cells
            switch (app, query, element) {
            case (.some, .none, .none):
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            case (.none, .some, .none):
                if let index = item.index {
                    return navigate(to: item.successor!, query: nil, element: query!.cells.element(boundBy: UInt(index)))
                } else {
                    return navigate(to: item.successor!, query: nil, element: query!.cells[item.key])
                }
            case (.none, .none, .some):
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            default:
                report.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            }
        case .layoutArea:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
        case .layoutItem:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .layoutItems:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .handle:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .stepper:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tab:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabs:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .touchBar:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .touchBars:
            report.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
        }
        
        /// Default failure
        var failed = Failed
        failed.1 = "No navigation item handled"
        return failed
    }
}
