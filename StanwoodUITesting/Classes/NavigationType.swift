//
//  XCTHelper.swift
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
        
        case segmentedControls
        
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
