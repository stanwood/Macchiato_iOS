//
//  Slack.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 28/12/2017.
//

import Foundation

extension UITesting {
    public struct Slack {
        
        /// Constants
        private struct SlackConstants {
            private init() {}
            static let baseURL: String = "https://hooks.slack.com/services/%@/%@"
            static let failureMessage: String = "Your tests have *failed!*"
            static let successMessage: String = "Your tests have *passed*, well done!"
        }
        
        private var url: URL? {
            return URL(string: String(format: SlackConstants.baseURL, teamID, channelToken))
        }
        
        /// Your Slack team ID, Example: T034UPBQE
        public let teamID: String
        
        /// Your channel service token, Example: B8K8L6S1Y/F6SKtmB1GoAbcDaTl00fuxtx
        public let channelToken: String
        
        public let channelName: String?
        
        public init(teamID: String, channelToken: String, channelName: String?) {
            self.teamID = teamID
            self.channelToken = channelToken
            self.channelName = channelName
        }
        
        func post(report: Report, completion: @escaping Completion) {
            guard let url = url else { return }
            
            // Headers
            let header = Header(value: "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            // Form URL-Encoded Body
            var payload: [String: Any] = [
                "username": "Bobby Testing",
                "icon_emoji": report.didPass ? ":fast-parrot:" : ":cop:",
                "attachments": [
                    [
                        "fallback": "UI Testing report",
                        "color": report.didPass ? "good" : "danger",
                        "pretext": report.didPass ? SlackConstants.successMessage : SlackConstants.failureMessage,
                        "title": "Report",
                        "text": report.review,
                        "fields": [
                            [
                                "title": "Priority",
                                "value": report.didPass ? "Low" : "High",
                                "short": true
                            ],
                            [
                                "title": "Bundle ID",
                                "value": report.bundleIdentifier,
                                "short": true
                            ]
                        ],
                        "footer": "Stanwood UI Testing API",
                        "mrkdwn_in": ["text", "pretext"],
                        "ts": Date().timeIntervalSince1970
                    ]
                ]
            ]
            
            if let channel = channelName {
                payload["channel"] = channel
            }
            
            guard let httpBody =  try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted) else { report.test(failed: Failure(message: "Slack json serialisation error")); return }
            
            Fetcher.sendRequest(with: url, URLParams: nil, HTTPMethod: .POST, headers: [header], body: httpBody, onCompletion: { _, _, _ in completion()})
        }
    }
}
