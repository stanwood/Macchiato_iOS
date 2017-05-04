//
//  Navigation.swift
//  JSONSchema
//
//  Created by Tal Zion on 22/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation

typealias JSONSchema = [AnyHashable:Any]

public enum NavigationError: Error {
    case error(String)
    case format(String)
}



extension String {
    
    func validate() throws {
        let split = self.components(separatedBy: ".")
        
        /// Checcking Schema for action
        guard split.contains("action") else { throw NavigationError.format("Schema does not contain an action") }
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
}

struct SchemaKey {
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
public class NavigationItem {
    
    public var type:NavigationType!
    public var index:Int?
    public var key:String!
    public var successor:NavigationItem?
    public var action:NavigationAction?
    public var sequence:Int!
    
    public init(format: String) throws {
        do {
            
            /// Validating Schema
            try format.validate()
            
            let components = format.components(separatedBy: ".")
            try convert(format: components)
            
        } catch  {
            throw error
        }
    }
    
    private init(dictionary: [AnyHashable:Any]) throws {
        do {
            try setup(schema: dictionary)
            
        } catch  {
            throw error
        }
    }
    
    private init(components:[String]) {
        transform(components: components)
    }
    
    /// MARK: - Private Helpers
    
    fileprivate func setup(schema: JSONSchema) throws {
        if let stringAction = schema[SchemaKey.action] as? String,
            let action = NavigationAction(rawValue: stringAction) {
            self.action = action
        }
        
        if let stringType = schema[SchemaKey.type] as? String,
            let type = NavigationType(rawValue: stringType) {
            self.type = type
        } else {
            throw NavigationError.error("Navigation Type does not exists")
        }
        
        self.index = schema[SchemaKey.index] as? Int
        self.key = schema[SchemaKey.key] as? String ?? ""
        self.sequence = schema[SchemaKey.order] as? Int ?? 0
        
        if let successorDictionary = schema[SchemaKey.successor] as? [AnyHashable:Any] {
            do {
                self.successor = try NavigationItem(dictionary: successorDictionary)
            } catch NavigationError.error(let m) {
                throw NavigationError.error(m)
            }
        }
    }
    
    fileprivate func convert(format: [String]) throws {
        
        /// Setting mutable format
        var format = format
        
        /// Assigning index
        guard let sequence = format.first?.toInt() else { throw NavigationError.format("Schema does not include a sequence index") }
        self.sequence = sequence
        
        /// Removing index
        format.removeFirst()
        
        /// Transformaing format to a Schema
        
        transform(components: format)
    }
    
    fileprivate func transform(components: [String]) {
        var components = components
        
        var elementType:NavigationType?
        var elementIndex:Int?
        var elementKey:String?
        
        var transforedIndex = 0
        
        for (index, format) in components.enumerated() {
            if let type = NavigationType(rawValue: format) {
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
            } else if let action = NavigationAction(rawValue: format) {
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
            self.successor = NavigationItem(components: components)
        }
    }
    
    fileprivate func set(type: NavigationType?, index: Int?, key: String?) {
        if let type = type {
            self.type = type
        }

        self.index = index
        self.key = key
    }
}
