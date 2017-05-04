//
//  ToolItem.swift
//  Glamour
//
//  Created by Tal Zion on 01/05/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation
import XCTest

public enum LaunchHandlers {
    case `default`
    case notification, review
}

public struct TestTool {
    
    /// JSON Schema URL
    let url:URL
    
    /// Launch handling dismiss default pop ups when launching the app
    let launchHandlers:[LaunchHandlers]
    
    /// Current running XCApplication
    let app: XCUIApplication
    
    public init(url: URL, launchHandlers: [LaunchHandlers], app: XCUIApplication) {
        self.url = url
        self.launchHandlers = launchHandlers
        self.app = app
    }
}
