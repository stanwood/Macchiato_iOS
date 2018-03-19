//
//  TestCases.swift
//  StanwoodUITesting
//
//  Created by Tal Zion on 19/03/2018.
//

import Foundation

extension UITesting {
    class TestCases: Codable {
        
        enum CodingKeys: String, CodingKey {
            case items = "test_cases"
            case shouldClearPreviousScreenshots = "clear_previous_screenshots"
            case isAutoScreenshots = "auto_screenshots"
            case initialSleepTime = "initial_sleep_time"
        }
        
        var items: [TestCase] = []
        var shouldClearPreviousScreenshots: Bool? = false
        var isAutoScreenshots: Bool? = false
        var initialSleepTime: UInt32?
        
        var numberOfItems: Int {
            return items.count
        }
        
        subscript(index: Int) -> TestCase {
            return items[index]
        }
        
        func removeAll() {
            items.removeAll()
        }
        
        func append(_ items: [TestCase]) {
            self.items.append(contentsOf: items)
        }
    }
    
}
