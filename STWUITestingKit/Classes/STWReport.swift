//
//  STWReports.swift
//  Glamour
//
//  Created by Tal Zion on 01/05/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation

class STWReport {
    
    /// Singleton
    static let shared: STWReport = STWReport()
    
    fileprivate var failures:[STWFailure] = []
    
    // MARK: - Printing the STWReport
    var print:String? {
        get {
            guard failures.count > 0 else { return nil }
            var print = "\nFailed Test Cases STWReport\n\nNumber of failed tests: \(failures.count)\n\n"
            
            for item in failures.enumerated() {
                print += "\nSTWSchema ID: \(item.element.testID == "0" ? "nil" : item.element.testID), \nNavigation ID: \(item.element.navigationID == 0 ? "nil" : "\(item.element.navigationID)"),\nFailure Message: \(item.element.errorMessage).\n\n"
            }
            return print
        }
    }
    
    // MARK: - Adding test failiures
    func test(failed item: STWFailure) {
        failures.append(item)
    }
}
