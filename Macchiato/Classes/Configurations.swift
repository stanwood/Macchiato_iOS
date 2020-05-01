//
//  Configurations.swift
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
import XCTest

extension Macchiato {
    
    public struct Configurations {
        
        /// JSON URL
        let url:URL?
        let filePath: URL?
        
        /// Current running XCApplication
        let app: XCUIApplication
        
        /// bundle identifier
        let bundleIdentifier: String
        
        /// Slack Channel ID
        public let slack: Slack?
        
        public init(contentsOfURL url: URL, bundleIdentifier: String, app: XCUIApplication, slack: Slack? = nil) {
            
            self.bundleIdentifier = bundleIdentifier
            self.url = url
            self.filePath = nil
            self.app = app
            self.slack = slack
        }
        
        public init(contentsOfFile url: URL?, bundleIdentifier: String, app: XCUIApplication, slack: Slack? = nil) {
            
            self.bundleIdentifier = bundleIdentifier
            self.filePath = url
            self.url = nil
            self.app = app
            self.slack = slack
        }
    }
}
