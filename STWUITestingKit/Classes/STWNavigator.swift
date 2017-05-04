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
    
    // MARK: - Navigation Actions
    
    fileprivate class func action(withItem item: STWNavigationItem, element: XCUIElement) -> (pass: Bool, failiurMessage: String) {
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
    
    class func navigate(to item: STWNavigationItem, query: XCUIElementQuery?, element: XCUIElement?,app:XCUIApplication? = nil) -> (pass: Bool, failiurMessage: String) {
        
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
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .other:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .application:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .group:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .window:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .windows:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .sheet:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .sheets:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .drawer:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .alert:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .alerts:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .dialog:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .dialogs:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
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
                STWReport.shared.test(failed: STWFailure(message: "XCTest Navigation failiur: Failed to fetach query or element"))
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
                STWReport.shared.test(failed: STWFailure(message: "XCTest Navigation failiur: Failed to fetach query or element"))
            }
            
        case .radioButton:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .radioButtons:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .radioGroup:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .checkBox:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .disclosureTriangle:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .popUpButton:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .popUpButtons:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .comboBox:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuButton:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuButtons:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolbarButton:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolbarButtons:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .popover:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .keyboard:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .key:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .navigationBar:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabBar:
            
            // MARK: - tabBar
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabBars:
            
            // MARK: - tabBars
            
            switch (app, query, element) {
            case (.some, .none, .none):
                return navigate(to: item.successor!, query: app!.tabBars, element: nil)
            case (.none, .some, .none):
                // TODO:
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            case (.none, .none, .some):
                // TODO:
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            default:
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            }
        case .tabGroup:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabGroups:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolbar:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toolBars:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .statusBar:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .table:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tables:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableRow:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableRows:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableColumn:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tableColumns:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .outline:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .outlineRow:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .browser:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .collectionView:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .collectionViews:
            
            // TODO:
            switch (app, query, element) {
            case (.some, .none, .none):
                return navigate(to: item.successor!, query: app!.collectionViews, element: nil)
            case (.none, .some, .none):
                // TODO:
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            case (.none, .none, .some):
                // TODO:
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            default:
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            }
        case .slider:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .pageIndicator:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .progressIndicator:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .activityIndicator:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .segmentedControl:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .picker:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .pickerWheel:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
        case .`switch`:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .toggle:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .link:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .image:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .images:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .icon:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .icons:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .searchField:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .searchFields:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollView:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollViews:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollBar:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .scrollBars:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .staticText:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textField:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textFields:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .secureTextField:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .secureTextFields:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .datePicker:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textView:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .textViews:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menu:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuItem:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuItems:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuBar:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .menuBarItem:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .map:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .webView:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .incrementArrow:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .decrementArrow:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .timeline:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .ratingIndicator:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .valueIndicator:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .splitGroup:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .splitter:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .relevanceIndicator:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .colorWell:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .helpTag:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .matte:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .dockItem:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .ruler:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .rulerMarker:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .grid:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .levelIndicator:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .cell:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .cells:
            
            // MARK: - cells
            switch (app, query, element) {
            case (.some, .none, .none):
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            case (.none, .some, .none):
                if let index = item.index {
                    return navigate(to: item.successor!, query: nil, element: query!.cells.element(boundBy: UInt(index)))
                } else {
                    return navigate(to: item.successor!, query: nil, element: query!.cells[item.key])
                }
            case (.none, .none, .some):
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            default:
                STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
                break
            }
        case .layoutArea:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
        case .layoutItem:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .layoutItems:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .handle:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .stepper:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tab:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .tabs:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .touchBar:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
            
        case .touchBars:
            STWReport.shared.test(failed: STWFailure(message: "Incomplete Implementation"))
            break
        }
        
        /// Default failure
        var failed = Failed
        failed.1 = "No navigation item handled"
        return failed
    }
}
