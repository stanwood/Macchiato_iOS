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

public struct Slack {
    
    /// Constants
    private struct SlackConstants {
        private init() {}
        static let baseURL: String = "https://hooks.slack.com/services/%@/%@"
        static let failureMessage: String = "Tests failed!"
        static let successMessage: String = "Tests passed!"
    }
    
    private var url: URL? {
        return URL(string: String(format: SlackConstants.baseURL, teamID, channelToken))
    }
    
    /// Your Slack team ID, Example: T034UPBQE
    public let teamID: String
    
    /// Your channel service token, Example: B8K8L6S1Y/F6SKtmB1GoAbcDaTl00fuxtx
    public let channelToken: String
    
    public init(teamID: String, channelToken: String) {
        self.teamID = teamID
        self.channelToken = channelToken
    }
    
    func post(report: STWReport) {
        guard let url = url else { return }
       
        // Headers
        let header = Header(value: "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
        // Form URL-Encoded Body
        let bodyParameters = [
            "{\"username\": \"Bill Testing\", \"text\": \"\(report.didPass ? SlackConstants.successMessage : SlackConstants.failureMessage + "\n" + report.print )\", \"icon_emoji\": \":santa:\"}": "",
            ]
        let bodyString = bodyParameters.queryParameters
        let httpBody = bodyString.data(using: .utf8, allowLossyConversion: true)
        
        STWFetcher.sendRequest(with: url, URLParams: nil, HTTPMethod: .POST, headers: [header], body: httpBody, onComplition: nil)
    }
}

public struct STWTestConfigurations {
    
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
