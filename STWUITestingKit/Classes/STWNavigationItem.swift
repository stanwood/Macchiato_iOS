//
//  Navigation.swift
//  JSONSTWSchema
//
//  Created by Tal Zion on 22/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation

typealias JSONSTWSchema = [AnyHashable:Any]

public enum NavigationError: Error {
    case error(String)
    case format(String)
}



extension String {
    
    func validate() throws {
        let split = self.components(separatedBy: ".")
        
        /// Checcking STWSchema for action
        guard split.contains("action") else { throw NavigationError.format("STWSchema does not contain an action") }
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
}

struct STWSchemaKey {
    static let action = "action"
    static let type = "type"
    static let index = "index"
    static let key = "key"
    static let order = "order"
    static let successor = "successor"
}

/*
 NavigationIten represents a navigation junction within a stack
 */
public class STWNavigationItem {
    
    public var type:STWNavigationType!
    public var index:Int?
    public var key:String!
    public var successor:STWNavigationItem?
    public var action:STWNavigationAction?
    public var sequence:Int!
    
    public init(format: String) throws {
        do {
            
            /// Validating STWSchema
            try format.validate()
            
            let components = format.components(separatedBy: ".")
            try convert(format: components)
            
        } catch  {
            throw error
        }
    }
    
    private init(dictionary: [AnyHashable:Any]) throws {
        do {
            try setup(STWSchema: dictionary)
            
        } catch  {
            throw error
        }
    }
    
    private init(components:[String]) {
        transform(components: components)
    }
    
    /// MARK: - Private Helpers
    
    fileprivate func setup(STWSchema: JSONSTWSchema) throws {
        if let stringAction = STWSchema[STWSchemaKey.action] as? String,
            let action = STWNavigationAction(rawValue: stringAction) {
            self.action = action
        }
        
        if let stringType = STWSchema[STWSchemaKey.type] as? String,
            let type = STWNavigationType(rawValue: stringType) {
            self.type = type
        } else {
            throw NavigationError.error("Navigation Type does not exists")
        }
        
        self.index = STWSchema[STWSchemaKey.index] as? Int
        self.key = STWSchema[STWSchemaKey.key] as? String ?? ""
        self.sequence = STWSchema[STWSchemaKey.order] as? Int ?? 0
        
        if let successorDictionary = STWSchema[STWSchemaKey.successor] as? [AnyHashable:Any] {
            do {
                self.successor = try STWNavigationItem(dictionary: successorDictionary)
            } catch NavigationError.error(let m) {
                throw NavigationError.error(m)
            }
        }
    }
    
    fileprivate func convert(format: [String]) throws {
        
        /// Setting mutable format
        var format = format
        
        /// Assigning index
        guard let sequence = format.first?.toInt() else { throw NavigationError.format("STWSchema does not include a sequence index") }
        self.sequence = sequence
        
        /// Removing index
        format.removeFirst()
        
        /// Transformaing format to a STWSchema
        
        transform(components: format)
    }
    
    fileprivate func transform(components: [String]) {
        var components = components
        
        var elementType:STWNavigationType?
        var elementIndex:Int?
        var elementKey:String?
        
        var transforedIndex = 0
        
        for (index, format) in components.enumerated() {
            if let type = STWNavigationType(rawValue: format) {
                if let _ = elementType {
                    transforedIndex = index - 1
                    break
                } else {
                    elementType = type
                }
            } else if let _index = format.toInt() {
                if let _ = elementIndex {
                    transforedIndex = index - 1
                    break
                } else {
                    elementIndex = _index
                }
            } else if let action = STWNavigationAction(rawValue: format) {
                self.action = action
                transforedIndex = index
                break
            } else {
                elementKey = format
                transforedIndex = index
                break
            }
        }
        
        
        /// Setting up successors
        set(type: elementType, index: elementIndex, key: elementKey)
        
        /// Removing added successors
        for _ in 0...transforedIndex {
            components.removeFirst()
        }
        
        /// Setting next successor inline
        if !components.isEmpty {
            self.successor = STWNavigationItem(components: components)
        }
    }
    
    fileprivate func set(type: STWNavigationType?, index: Int?, key: String?) {
        if let type = type {
            self.type = type
        }

        self.index = index
        self.key = key
    }
}
