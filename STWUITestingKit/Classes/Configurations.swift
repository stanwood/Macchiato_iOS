//
//  Configurations.swift
//  UI Testing
//
//  Created by Tal Zion on 01/05/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation
import XCTest

typealias Completion = () -> Void

public enum LaunchHandlers {
    case `default`
    case notification, review
}

extension UITesting {
    
    public struct Configurations {
        
        /// JSON STWSchema URL
        let url:URL
        
        /// Launch handling dismiss default pop ups when launching the app
        let launchHandlers:[LaunchHandlers]
        
        /// Current running XCApplication
        let app: XCUIApplication
        
        /// Slack Channel ID
        public let slack: Slack?
        
        public init(url: URL, launchHandlers: [LaunchHandlers], app: XCUIApplication, slack: Slack? = nil) {
            self.url = url
            self.launchHandlers = launchHandlers
            self.app = app
            self.slack = slack
        }
    }
}
