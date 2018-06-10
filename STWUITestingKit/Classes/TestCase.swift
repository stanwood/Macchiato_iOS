 //
 //  XCTHelper.swift
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
 
 extension String {
    func stringByRemovingPrefix(_ prefix:String) -> String? {
        if hasPrefix(prefix) {
            let index = self.index(startIndex, offsetBy: prefix.count)
            return substring(from: index)
        }
        
        return nil
    }
 }
 
 extension UITesting {
    
    public struct TestCase: Codable {
        
        enum CodingKeys: String, CodingKey {
            case title, id, description
            case navigationItems = "navigation"
        }
        
        public let title: String?
        public let description: String?
        public let id: String?
        
        public var navigationItems: [NavigationItem] = []
        
        public init(testCase: [AnyHashable: Any]) throws {
            id = testCase["id"] as? String
            title = testCase["title"] as? String
            description = testCase["description"] as? String
            
            guard let _ = id, let _ = title, let _ = description else {
                throw TestError.error(message: "Incorrect Foramt - Please check id, title, and description\n ID: \(id ?? "nil"), Title: \(title ?? "nil"), Description: \(description ?? "nil")", id: id, navigationIndex: nil)
            }
            
            if let navigationArray = testCase["navigation"] as? [Any] {
                for (index, item) in navigationArray.enumerated() {
                    
                    guard var itemFormat = item as? String else { continue }
                    itemFormat = re(format: itemFormat, with: index)
                    
                    /// Checking for incorrect item foramt key and index
                    if itemFormat.contains("..") {
                        throw TestError.error(message: "Navigation item format error, missing key or index", id: id, navigationIndex: index)
                    }
                    
                    do {
                        let navigationItem = try NavigationItem(format: itemFormat)
                        self.navigationItems.append(navigationItem)
                    } catch UITesting.TestError.error(let m) {
                        throw TestError.error(message: m.message, id: id, navigationIndex: index)
                    }
                }
                
                self.navigationItems.sort(by: { (itemOne, itemTwo) -> Bool in
                    return itemOne.sequence < itemTwo.sequence
                })
            } else {
                /// Throwing an error in case test has no navigation items
                throw TestError.error(message: "Failed to set test case - No **Navigation Items**!", id: id, navigationIndex: nil)
            }
        }
        
        public init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            title = try container.decodeIfPresent(String.self, forKey: .title)
            description = try container.decodeIfPresent(String.self, forKey: .description)
            id = try container.decodeIfPresent(String.self, forKey: .id)
            
            guard let _ = id, let _ = title, let _ = description else {
                throw TestError.error(message: "Incorrect Foramt - Please check id, title, and description\n ID: \(id ?? "nil"), Title: \(title ?? "nil"), Description: \(description ?? "nil")", id: id, navigationIndex: nil)
            }
            
            let items = try container.decodeIfPresent([String].self, forKey: .navigationItems)
            if let navigationArray = items {
                for (index, item) in navigationArray.enumerated() {
                    
                    let itemFormat = re(format: item, with: index)
                    
                    /// Checking for incorrect item foramt key and index
                    if itemFormat.contains("..") {
                        throw TestError.error(message: "Navigation item format error, missing key or index", id: id, navigationIndex: index)
                    }
                    
                    do {
                        let navigationItem = try NavigationItem(format: itemFormat)
                        self.navigationItems.append(navigationItem)
                    } catch UITesting.TestError.error(let m) {
                        throw TestError.error(message: m.message, id: id, navigationIndex: index)
                    }
                }
                
                self.navigationItems.sort(by: { (itemOne, itemTwo) -> Bool in
                    return itemOne.sequence < itemTwo.sequence
                })
            } else {
                /// Throwing an error in case test has no navigation items
                throw TestError.error(message: "Failed to set test case - No **Navigation Items**!", id: id, navigationIndex: nil)
            }
        }
        
        private func re(format: String, with index: Int) -> String {
            return "\(index + 1).\(format)".replacingOccurrences(of: "['", with: ".").replacingOccurrences(of: "[", with: ".").replacingOccurrences(of: "']", with: "").replacingOccurrences(of: "]", with: "")
        }
    }
 }
