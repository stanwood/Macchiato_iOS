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
 
 typealias Complition = (_ STWSchemaCases:[STWSchema]) -> Void
 
 class XCTHelper {
    
    // MARK: Fetcher - Networking
    
    class open func fetchSTWSchema(withUrl url:URL, complition:@escaping Complition) {
        
        STWFetcher.getRequest(URL: url, URLParams: nil, HTTPMethod: .GET, headers: nil, onComplition: {
            dictionary, repsosne, error in
            
            var testCases:[STWSchema] = []
            
            if var dic = dictionary as? [String : Any], let schemas = dic["test_cases"] as? NSArray {
                for schema in schemas {
                    guard let schemaDictionary = schema as? [String:Any] else { continue }
                    do {
                        let testCase = try STWSchema(schemaDictionary)
                        
                        testCases.append(testCase)
                    } catch SchemaError.error(let m) {
                        STWReport.shared.test(failed: STWFailure(message: m))
                    }
                }
                complition(testCases)
            } else {
                STWReport.shared.test(failed: STWFailure(message: "Failed to download JSONSTWSchema from: \(url)"))
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
