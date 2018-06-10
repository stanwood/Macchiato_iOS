//
//  Action.swift
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
    
    public enum Action: RawRepresentable, Codable {
        
        case tap
        case isHittable
        case exists
        case swipeUp
        case swipeDown
        case swipeLeft
        case swipeRight
        case screenshot
        case type(String)
        
        public init?(rawValue: String) {
            var rawValue = rawValue
            var text = ""
            if rawValue.contains("type") {
                let componants = rawValue.components(separatedBy: "\"").filter({ !$0.isEmpty })
                rawValue = componants.first ?? ""
                text = componants.last ?? ""
            }
            switch rawValue {
            case "exists":
                self = .exists
            case "isHittable":
                self = .isHittable
            case "screenshot":
                self = .screenshot
            case "swipeDown":
                self = .swipeDown
            case "swipeLeft":
                self = .swipeLeft
            case "swipeRight":
                self = .swipeRight
            case "swipeUp":
                self = .swipeUp
            case "tap":
                self = .tap
            case "type":
                self = .type(text)
            default:
                return nil
            }
        }
        
        public var rawValue: String {
            switch self {
            case .exists:
                return "exists"
            case .isHittable:
                return "isHittable"
            case .screenshot:
                return "screenshot"
            case .swipeDown:
                return "swipeDown"
            case .swipeLeft:
                return "swipeLeft"
            case .swipeRight:
                return "swipeRight"
            case .swipeUp:
                return "swipeUp"
            case .tap:
                return "tap"
            case .type( let text):
                return "type(\(text)"
            }
        }
        
        public typealias RawValue = String
    }
}
