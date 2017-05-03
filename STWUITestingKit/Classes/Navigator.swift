//
//  Navigator.swift
//  Glamour
//
//  Created by Tal Zion on 01/05/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation
import XCTest

class Navigator {
    
    // MARK: - Navigation Actions
    
    fileprivate class func action(withItem item: NavigationItem, element: XCUIElement) -> (pass: Bool, failiurMessage: String) {
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
    
    class func navigate(to item: NavigationItem, query: XCUIElementQuery?, element: XCUIElement?,app:XCUIApplication? = nil) -> (pass: Bool, failiurMessage: String) {
        
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
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .other:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .application:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .group:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .window:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .windows:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .sheet:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .sheets:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .drawer:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .alert:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .alerts:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .dialog:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .dialogs:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
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
                Report.shared.test(failed: FailureItem(message: "XCTest Navigation failiur: Failed to fetach query or element"))
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
                Report.shared.test(failed: FailureItem(message: "XCTest Navigation failiur: Failed to fetach query or element"))
            }
            
        case .radioButton:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .radioButtons:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .radioGroup:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .checkBox:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .disclosureTriangle:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .popUpButton:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .popUpButtons:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .comboBox:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .menuButton:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .menuButtons:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .toolbarButton:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .toolbarButtons:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .popover:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .keyboard:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .key:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .navigationBar:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tabBar:
            
            // MARK: - tabBar
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tabBars:
            
            // MARK: - tabBars
            
            switch (app, query, element) {
            case (.some, .none, .none):
                return navigate(to: item.successor!, query: app!.tabBars, element: nil)
            case (.none, .some, .none):
                // TODO:
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            case (.none, .none, .some):
                // TODO:
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            default:
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            }
        case .tabGroup:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tabGroups:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .toolbar:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .toolBars:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .statusBar:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .table:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tables:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tableRow:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tableRows:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tableColumn:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tableColumns:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .outline:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .outlineRow:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .browser:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .collectionView:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .collectionViews:
            
            // TODO:
            switch (app, query, element) {
            case (.some, .none, .none):
                return navigate(to: item.successor!, query: app!.collectionViews, element: nil)
            case (.none, .some, .none):
                // TODO:
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            case (.none, .none, .some):
                // TODO:
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            default:
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            }
        case .slider:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .pageIndicator:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .progressIndicator:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .activityIndicator:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .segmentedControl:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .picker:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .pickerWheel:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
        case .`switch`:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .toggle:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .link:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .image:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .images:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .icon:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .icons:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .searchField:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .searchFields:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .scrollView:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .scrollViews:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .scrollBar:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .scrollBars:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .staticText:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .textField:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .textFields:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .secureTextField:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .secureTextFields:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .datePicker:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .textView:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .textViews:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .menu:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .menuItem:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .menuItems:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .menuBar:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .menuBarItem:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .map:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .webView:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .incrementArrow:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .decrementArrow:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .timeline:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .ratingIndicator:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .valueIndicator:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .splitGroup:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .splitter:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .relevanceIndicator:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .colorWell:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .helpTag:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .matte:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .dockItem:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .ruler:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .rulerMarker:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .grid:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .levelIndicator:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .cell:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .cells:
            
            // MARK: - cells
            switch (app, query, element) {
            case (.some, .none, .none):
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            case (.none, .some, .none):
                if let index = item.index {
                    return navigate(to: item.successor!, query: nil, element: query!.cells.element(boundBy: UInt(index)))
                } else {
                    return navigate(to: item.successor!, query: nil, element: query!.cells[item.key])
                }
            case (.none, .none, .some):
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            default:
                Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
                break
            }
        case .layoutArea:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
        case .layoutItem:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .layoutItems:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .handle:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .stepper:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tab:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .tabs:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .touchBar:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
            
        case .touchBars:
            Report.shared.test(failed: FailureItem(message: "Incomplete Implementation"))
            break
        }
        
        /// Default failure
        var failed = Failed
        failed.1 = "No navigation item handled"
        return failed
    }
}
