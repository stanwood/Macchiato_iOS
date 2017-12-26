 //
 //  XCTHelper.swift
 //  Glamour
 //
 //  Created by Tal Zion on 22/03/2017.
 //  Copyright © 2017 Stanwood GmbH. All rights reserved.
 //
 
 import Foundation
 
 public enum SchemaError: Error {
    case error(String)
 }
 
 
 extension String {
    func stringByRemovingPrefix(_ prefix:String) -> String? {
        if hasPrefix(prefix) {
            let index = characters.index(startIndex, offsetBy: prefix.characters.count)
            return substring(from: index)
        }
        
        return nil
    }
 }
 
 public struct TestCase {
    
    public let title:String?
    public let description:String?
    public let id:String?
    
    public var STWNavigationItems:[STWNavigationItem] = []
    
    let testCase: [AnyHashable:Any]
    
    public init(testCase: [AnyHashable:Any]) throws {
        
        id = testCase["id"] as? String
        title = testCase["title"] as? String
        description = testCase["description"] as? String
        
        guard let _ = id, let _ = title, let _ = description else {
            throw SchemaError.error("Incorrect Schema Foramt - Please check id, title, and description\n ID: \(id ?? "nil"), Title: \(title ?? "nil"), Description: \(description ?? "nil")")
        }
        
        self.testCase = testCase
        
        if let navigationArray = testCase["navigation"] as? [Any] {
            for (index, item) in navigationArray.enumerated() {
                guard var itemFormat = item as? String else { continue }
                itemFormat = re(format: itemFormat, with: index)
                
                /// Checking for incorrect item foramt key and index
                if itemFormat.contains("..") {
                    throw SchemaError.error("Navigation item format error, missing key or index")
                }
                
                do {
                    let navigationItem = try STWNavigationItem(format: itemFormat)
                    self.STWNavigationItems.append(navigationItem)
                } catch SchemaError.error(let m) {
                    throw SchemaError.error(m)
                }
            }
            
            self.STWNavigationItems.sort(by: { (itemOne, itemTwo) -> Bool in
                return itemOne.sequence < itemTwo.sequence
            })
        } else {
            /// Throwing an error in case test has no navigation items
            throw SchemaError.error("Failed to set Schema test - No Navigation Items!")
        }
    }
    
    private func re(format: String, with index: Int) -> String {
        return "\(index + 1).\(format)".replacingOccurrences(of: "['", with: ".").replacingOccurrences(of: "[", with: ".").replacingOccurrences(of: "']", with: "").replacingOccurrences(of: "]", with: "")
    }
 }
