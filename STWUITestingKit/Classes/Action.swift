//
//  STWNavigationAction.swift
//  JSONSTWSchema
//
//  Created by Tal Zion on 22/03/2017.
//  Copyright © 2017 Cocode. All rights reserved.
//

import Foundation

extension UITesting {
    
    public enum Action: RawRepresentable {
        
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
                self = .tap
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
