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
 
 typealias Completion = () -> Void
 
 extension UITesting {
    
    class Helper {
        
        // MARK: Fetcher - Networking
        
        class open func fetchElement<Element: Decodable>(withUrl url: URL, report: Report, completion: @escaping (_ element: Element?) -> Void) {
            
            URLCache.shared.removeAllCachedResponses()
            
            Fetcher.sendRequest(with: url, URLParams: nil, HTTPMethod: .GET, headers: nil, body: nil) { (data, response, error) in
                
                if let data = data {
                    do {
                        let tests = try JSONDecoder().decode(Element.self, from: data)
                        completion(tests)
                    } catch UITesting.TestError.error(let error) {
                        report.test(failed: Failure(testID: error.id, navigationID: error.navigationIndex, message: error.message))
                        completion(nil)
                    } catch let error {
                        report.test(failed: Failure(testID: nil, navigationID: nil, message: error.localizedDescription))
                        completion(nil)
                    }
                } else {
                    report.test(failed: Failure(message: "Failed to download test cases from: \(url.absoluteString). \nPlease check your bundle and version and make sure test cases were added."))
                    completion(nil)
                }
            }
            
        }
        
        // MARK: Dismissing Pop Ups
        
        class open func close(withApp app: XCUIApplication){
            let iconCloseButton = app.buttons["icon close"]
            if iconCloseButton.exists, iconCloseButton.isHittable {
                iconCloseButton.tap()
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
