 //
 //  XCTHelper.swift
 //  Glamour
 //
 //  Created by Tal Zion on 22/03/2017.
 //  Copyright © 2017 Stanwood GmbH. All rights reserved.
 //
 
 import XCTest
 
 let Passed = (true, "")
 var Failed = (false, "")
 
 typealias Complition = (_ schemaCases:[Schema]) -> Void
 
 class XCTHelper {
    
    // MARK: Fetcher - Networking
    
    class open func fetchSchema(withUrl url:URL, complition:@escaping Complition) {
        
        FetchRequestController.getRequest(URL: url, URLParams: nil, HTTPMethod: .GET, headers: nil, onComplition: {
            dictionary, repsosne, error in
            
            var testCases:[Schema] = []
            
            if var dic = dictionary as? [String : Any], let schemas = dic["test_cases"] as? NSArray {
                for schema in schemas {
                    guard let schemaDictionary = schema as? [String:Any] else { continue }
                    do {
                        let testCase = try Schema(schemaDictionary)
                        testCases.append(testCase)
                    } catch NavigationError.error(let m) {
                        Report.shared.test(failed: FailureItem(message: m))
                    } catch NavigationError.format(let m) {
                        Report.shared.test(failed: FailureItem(message: m))
                    }
                }
                complition(testCases)
            } else {
                Report.shared.test(failed: FailureItem(message: "Failed to download JSONSchema from: \(url)"))
            }
        })
    }
    
    // MARK: Dismissing Pop Ups
    
    class open func close(withApp app: XCUIApplication){
        let iconCloseButton = app.buttons["icon close"]
        if iconCloseButton.exists, iconCloseButton.isHittable {
            iconCloseButton.tap()
        }
    }
    
    class open func allowNotifications(withApp app: XCUIApplication){
        
        let allowButton = app.alerts.element(boundBy: 0).buttons.element(boundBy: 0)
        if allowButton.exists, allowButton.isHittable {
            allowButton.tap()
        }
    }
    
    class open func dismissReviewAlert(withApp app: XCUIApplication){
        var button:XCUIElement = app.buttons["Nein, danke"]
        if button.exists, button.isHittable {
            button.tap()
        } else {
            button = app.buttons["No"]
            if button.exists, button.isHittable {
                button.tap()
            }
        }
    }
    
    class open func navigateToDefault(app:XCUIApplication){
        sleep(3)
        app.terminate()
        sleep(3)
        app.setupAndLaunch()
    }
}
