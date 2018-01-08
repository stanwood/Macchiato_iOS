//
//  TestError.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 28/12/2017.
//

import Foundation

extension UITesting {
    public enum TestError: Error {
        case error(message: String, id: String?, navigationIndex: Int?)
    }
}

