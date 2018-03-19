//
//  XCTHelper.swift
//  UITesting
//
//  Created by Tal Zion on 22/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation

extension UITesting {
    
    public enum NavigationType: String, Codable {
        case action
        
        case any
        
        case other
        
        case application
        
        case group
        
        case windows
        
        case sheets
        
        case drawer
        
        case alerts
        
        case dialogs
        
        case buttons
        
        case radioButtons
        
        case checkBox
        
        case disclosureTriangle
        
        case popUpButton
        
        case popUpButtons
        
        case comboBox

        case menuButtons
        
        case toolbarButtons
        
        case popover
        
        case keyboard
        
        case key
        
        case navigationBars
        
        case tabBars
        
        case tabGroups
        
        case toolBars
        
        case statusBar
        
        case tables
        
        case tableRows
        
        case tableColumns
        
        case outline
        
        case outlineRow
        
        case browser
        
        case collectionViews
        
        case pageIndicator
        
        case progressIndicator
        
        case activityIndicator
        
        case segmentedControl
        
        case picker
        
        case pickerWheel
        
        case `switch`
        
        case toggle
        
        case link
    
        case images
        
        case icons
        
        case searchField
        
        case searchFields
        
        case scrollViews
        
        case scrollBars
        
        case staticText
        
        case textFields
        
        case secureTextFields
        
        case datePicker
        
        case textViews
        
        case menu
        
        case menuItems
        
        case menuBar
        
        case menuBarItem
        
        case map
        
        case webView
        
        case incrementArrow
        
        case decrementArrow
        
        case timeline
        
        case ratingIndicator
        
        case valueIndicator
        
        case splitGroup
        
        case splitter
        
        case relevanceIndicator
        
        case colorWell
        
        case helpTag
        
        case matte
        
        case dockItem
        
        case ruler
        
        case rulerMarker
        
        case grid
        
        case levelIndicator
        
        case cells
        
        case layoutArea
        
        case layoutItems
        
        case handle
        
        case stepper
        
        case tabs
        
        case touchBars
    }
}
