//
//  Configurations.swift
//  UI Testing
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

extension UITesting {
    
    public struct Configurations {
        
        /// JSON URL
        let url:URL
        
        /// Launch handling dismiss default pop ups when launching the app
        let launchHandlers:[LaunchHandlers]
        
        /// Current running XCApplication
        let app: XCUIApplication
        
        /// Slack Channel ID
        public let slack: Slack?
        
        public init?(bundleId: String, version: String, launchHandlers: [LaunchHandlers], app: XCUIApplication, slack: Slack? = nil) {
            
            let baseURLString: String = "https://stanwood-ui-testing.firebaseio.com"
            let version: String = version.replacingOccurrences(of: ".", with: "-")
            guard let url = URL(string: "ios/\(bundleId)/\(version).json", relativeTo: URL(string: baseURLString)) else { XCTFail("incorrect base url"); return nil }
            
            self.url = url
            self.launchHandlers = launchHandlers
            self.app = app
            self.slack = slack
        }
    }
}
