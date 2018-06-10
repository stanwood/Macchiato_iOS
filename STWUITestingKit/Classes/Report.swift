//
//  STWReports.swift
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

extension UITesting {
    
    class Report {
        
        fileprivate var failures:[Failure] = []
        
        let bundleIdentifier: String
        
        init(bundleId: String) {
            bundleIdentifier = bundleId
        }
        
        /// Checking if tests did pass
        var didPass: Bool {
            return failures.count == 0
        }
        
        // MARK: - Printing the STWReport
        var review: String {
            
            get {
                guard !didPass else { return "Test passed!" }
                var print = "\n*Test Report*\n\nNumber of failed tests: \(failures.count)\n\n"
                
                failures.forEach({
                    
                    if let id = $0.testID {
                        print += "\n*Test ID:* \(id)"
                    }
                    
                    if let navigationId = $0.navigationID {
                        print += "\n*Item ID:* \(navigationId)"
                    }
                    
                    let title = $0.navigationID == nil && $0.testID == nil ? "\n*System Error*" : ""
                    print += "\(title)\n*Error Message:* \($0.errorMessage).\n\n"
                })
                
                print += "\n \n "
                return print
            }
        }
        
        // MARK: - Adding test failiures
        func test(failed item: Failure) {
            failures.append(item)
        }
    }
}
