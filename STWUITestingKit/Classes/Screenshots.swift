//
//  Screenshots.swift
//  STWUITestingKit
//
//  Created by Tal Zion on 04/01/2018.
//

import Foundation
import XCTest

private struct Screenshot {
    let data: Data
    let name: String
}

class Screenshots  {
    
    private let folder: String = "uitesting_screenshots"
    private var screenshots: [Screenshot] = []
    private var app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func save(shouldClearPreviousScreenshots: Bool = false) throws {
        
        /// Checking if there are any screenshots to save
        guard screenshots.count > 0 else { return }
        
        do {
            
            let screenshotsDirectory = try homeDirectory()?.appendingPathComponent(folder, isDirectory: true)
            guard let simulator = ProcessInfo().environment["SIMULATOR_DEVICE_NAME"], let screenshotsDir = screenshotsDirectory else { return }
            
            if shouldClearPreviousScreenshots {
                if let contents = try? FileManager.default.contentsOfDirectory(at: screenshotsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                    contents.forEach({ url in
                        try? FileManager.default.removeItem(at: url)
                    })
                }
            }
            
            try? FileManager.default.createDirectory(at: screenshotsDir, withIntermediateDirectories: true, attributes: nil)
            
            
            try screenshots.forEach({ (screenshot) in
                
                do {
                    let path = screenshotsDir.appendingPathComponent("\(simulator.replacingOccurrences(of: " ", with: "_"))-\(screenshot.name).png")
                    try screenshot.data.write(to: path)
                } catch let error {
                    throw error
                }
            })
        } catch {
            throw error
        }
    }
    
    func takeSnapshot(_ name: String = UUID().uuidString, timeWaitingForIdle timeout: TimeInterval = 10) {
        if timeout > 0 {
            waitForLoadingIndicatorToDisappear(within: timeout)
        }
        
        sleep(1) // Waiting for the animation to be finished
        
        // Taking screenshot
        let screenshotElement = app.windows.firstMatch.screenshot()
        let screenshot = Screenshot(data: screenshotElement.pngRepresentation, name: name)
        
        screenshots.append(screenshot)
    }
    
    private func waitForLoadingIndicatorToDisappear(within timeout: TimeInterval) {
        
        let networkLoadingIndicator = XCUIApplication().otherElements.deviceStatusBars.networkLoadingIndicators.element
        let networkLoadingIndicatorDisappeared = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: networkLoadingIndicator)
        _ = XCTWaiter.wait(for: [networkLoadingIndicatorDisappeared], timeout: timeout)
    }
    
    private func homeDirectory() throws -> URL? {
        guard let simulatorHostHome = ProcessInfo.processInfo.environment["SRCROOT"] else {
            throw UITesting.TestError.error(message: "Couldn't find project source location. Please check *SRCROOT* env variable or follow the docs for more information", id: nil, navigationIndex: nil)
        }
        guard let homeDirUrl = URL(string: simulatorHostHome) else {
            return nil
        }
        
        return URL(fileURLWithPath: homeDirUrl.path)
    }
}

private extension CGFloat {
    func isBetween(_ numberA: CGFloat, and numberB: CGFloat) -> Bool {
        return numberA...numberB ~= self
    }
}

private extension XCUIElementAttributes {
    var isNetworkLoadingIndicator: Bool {
        if hasWhiteListedIdentifier { return false }
        
        let hasOldLoadingIndicatorSize = frame.size == CGSize(width: 10, height: 20)
        let hasNewLoadingIndicatorSize = frame.size.width.isBetween(46, and: 47) && frame.size.height.isBetween(2, and: 3)
        
        return hasOldLoadingIndicatorSize || hasNewLoadingIndicatorSize
    }
    
    var hasWhiteListedIdentifier: Bool {
        let whiteListedIdentifiers = ["GeofenceLocationTrackingOn", "StandardLocationTrackingOn"]
        
        return whiteListedIdentifiers.contains(identifier)
    }
    
    func isStatusBar(_ deviceWidth: CGFloat) -> Bool {
        if elementType == .statusBar { return true }
        guard frame.origin == .zero else { return false }
        
        let oldStatusBarSize = CGSize(width: deviceWidth, height: 20)
        let newStatusBarSize = CGSize(width: deviceWidth, height: 44)
        
        return [oldStatusBarSize, newStatusBarSize].contains(frame.size)
    }
}

private extension XCUIElementQuery {
    var networkLoadingIndicators: XCUIElementQuery {
        let isNetworkLoadingIndicator = NSPredicate { (evaluatedObject, _) in
            guard let element = evaluatedObject as? XCUIElementAttributes else { return false }
            
            return element.isNetworkLoadingIndicator
        }
        
        return self.containing(isNetworkLoadingIndicator)
    }
    
    var deviceStatusBars: XCUIElementQuery {
        let deviceWidth = XCUIApplication().frame.width
        
        let isStatusBar = NSPredicate { (evaluatedObject, _) in
            guard let element = evaluatedObject as? XCUIElementAttributes else { return false }
            
            return element.isStatusBar(deviceWidth)
        }
        
        return self.containing(isStatusBar)
    }
}
