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

public struct STWSchema {
    public let title:String?
    public let description:String?
    public let id:String?
    
    public var STWNavigationItems:[STWNavigationItem] = []
    
    let STWSchema:[String:Any]
    
    public init(_ STWSchema:[String:Any]) throws {
        
        id = STWSchema["id"] as? String
        title = STWSchema["title"] as? String
        description = STWSchema["description"] as? String
        
        self.STWSchema = STWSchema
        
        if let navigationArray = STWSchema["navigation"] as? [Any] {
            for (index, item) in navigationArray.enumerated() {
                guard var itemFormat = item as? String else { continue }
                itemFormat = re(format: itemFormat, with: index)
                do {
                    let navigationItem = try STWNavigationItem(format: itemFormat)
                    self.STWNavigationItems.append(navigationItem)
                } catch NavigationError.error(let m) {
                    throw NavigationError.error(m)
                }
            }
            
            self.STWNavigationItems.sort(by: { (itemOne, itemTwo) -> Bool in
                return itemOne.sequence < itemTwo.sequence
            })
        }
    }
    
    private func re(format: String, with index: Int) -> String {
        return "\(index + 1).\(format)".replacingOccurrences(of: "['", with: ".").replacingOccurrences(of: "[", with: ".").replacingOccurrences(of: "']", with: "").replacingOccurrences(of: "]", with: "")
    }
}
