 //
 //  XCTHelper.swift
 //  UITesting
 //
 //  Created by Tal Zion on 22/03/2017.
 //  Copyright © 2017 Stanwood GmbH. All rights reserved.
 //
 
 import XCTest
 
 let Passed = (true, "")
 var Failed = (false, "")
 
 typealias Complition = (_ STWSchemaCases:[UITesting.TestCase]) -> Void
 
 extension UITesting {
    
    class Helper {
        
        // MARK: Fetcher - Networking
        
        class open func fetchSTWSchema(withUrl url:URL, report: Report, complition: @escaping Complition) {
            
            Fetcher.sendRequest(with: url, URLParams: nil, HTTPMethod: .GET, headers: nil, body: nil, onComplition: {
                dictionary, repsosne, error in
                
                var tests:[TestCase] = []
                
                if var dic = dictionary as? [String : Any], let testCases = dic["test_cases"] as? NSArray {
                    for testCase in testCases {
                        guard let testCaseDictionary = testCase as? [String:Any] else { continue }
                        do {
                            let test = try TestCase(testCase: testCaseDictionary)
                            
                            tests.append(test)
                        } catch UITesting.TestError.error(let m) {
                            report.test(failed: Failure(message: m))
                        }
                    }
                    complition(tests)
                } else {
                    report.test(failed: Failure(message: "Failed to download JSONSTWSchema from: \(url)"))
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
 }
