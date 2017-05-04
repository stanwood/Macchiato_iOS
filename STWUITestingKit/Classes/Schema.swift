 //
 //  XCTHelper.swift
 //  Glamour
 //
 //  Created by Tal Zion on 22/03/2017.
 //  Copyright © 2017 Stanwood GmbH. All rights reserved.
 //
 
import Foundation

extension String {
    func stringByRemovingPrefix(_ prefix:String) -> String? {
        if hasPrefix(prefix) {
            let index = characters.index(startIndex, offsetBy: prefix.characters.count)
            return substring(from: index)
        }
        
        return nil
    }
}

public struct Schema {
    public let title:String?
    public let description:String?
    public let id:String?
    
    public var navigationItems:[NavigationItem] = []
    
    let schema:[String:Any]
    
    public init(_ schema:[String:Any]) throws {
        
        id = schema["id"] as? String
        title = schema["title"] as? String
        description = schema["description"] as? String
        
        self.schema = schema
        
        if let navigationArray = schema["navigation"] as? [Any] {
            for (index, item) in navigationArray.enumerated() {
                guard var itemFormat = item as? String else { continue }
                itemFormat = re(format: itemFormat, with: index)
                do {
                    let navigationItem = try NavigationItem(format: itemFormat)
                    self.navigationItems.append(navigationItem)
                } catch NavigationError.error(let m) {
                    throw NavigationError.error(m)
                }
            }
            
            self.navigationItems.sort(by: { (itemOne, itemTwo) -> Bool in
                return itemOne.sequence < itemTwo.sequence
            })
        }
    }
    
    private func re(format: String, with index: Int) -> String {
        return "\(index + 1).\(format)".replacingOccurrences(of: "['", with: ".").replacingOccurrences(of: "[", with: ".").replacingOccurrences(of: "']", with: "").replacingOccurrences(of: "]", with: "")
    }
}