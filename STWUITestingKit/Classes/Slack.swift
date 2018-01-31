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
            static let failureMessage: String = "Your tests have *failed!*"
            static let successMessage: String = "Your tests have *passed*, well done!"
        }
        
        private let url: URL
        public let channelName: String?
        
        public init(webhookURL url: URL, channelName: String? = nil) {
            self.url = url
            self.channelName = channelName
        }
        
        func post(report: Report, completion: @escaping Completion) {
    
            // Headers
            let header = Header(value: "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let simulator = ProcessInfo().environment["SIMULATOR_DEVICE_NAME"]
            
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
                            ],
                            [
                                "title": "Device",
                                "value": simulator ?? "unknown",
                                "short": true
                            ],
                            [
                                "title": "OS",
                                "value": UIDevice.current.systemVersion,
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
