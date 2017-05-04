//
//  Reports.swift
//  Glamour
//
//  Created by Tal Zion on 01/05/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

import Foundation

class Report {
    
    /// Singleton
    static let shared: Report = Report()
    
    fileprivate var failures:[FailureItem] = []
    
    // MARK: - Printing the report
    var print:String? {
        get {
            guard failures.count > 0 else { return nil }
            var print = "Failed Test Cases Report\n\nNumber of failed tests: \(failures.count)\n\n"
            
            for item in failures.enumerated() {
                print += "Report \(item.offset + 1).\nSchema ID: \(item.element.testID == "0" ? "nil" : item.element.testID), \nNavigation ID: \(item.element.navigationID == 0 ? "nil" : "\(item.element.navigationID)"),\nFailure Message: \(item.element.errorMessage).\n\n"
            }
            return print
        }
    }
    
    // MARK: - Adding test failiures
    func test(failed item: FailureItem) {
        failures.append(item)
    }
}
