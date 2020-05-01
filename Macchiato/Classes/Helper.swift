 //
 //  XCTHelper.swift
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
 
 import XCTest
 
 let Passed = (true, "")
 var Failed = (false, "")
 
 typealias Completion = () -> Void
 
 extension Macchiato {
    
    class Helper {
        
        // MARK: Fetcher - Networking
        
        class open func loadElement<Element: Decodable>(fromFile url: URL, report: Report, completion: @escaping (_ element: Element?) -> Void) {
            do {
                let data = try Data(contentsOf: url)
                let tests = try JSONDecoder().decode(Element.self, from: data)
                completion(tests)
            } catch Macchiato.TestError.error(let error) {
                report.test(failed: Failure(testID: error.id, navigationID: error.navigationIndex, message: error.message))
                completion(nil)
            } catch let error {
                report.test(failed: Failure(testID: nil, navigationID: nil, message: error.localizedDescription))
                completion(nil)
            }
        }
        
        class open func fetchElement<Element: Decodable>(withUrl url: URL, report: Report, completion: @escaping (_ element: Element?) -> Void) {
            
            URLCache.shared.removeAllCachedResponses()
            
            Fetcher.sendRequest(with: url, URLParams: nil, HTTPMethod: .GET, headers: nil, body: nil) { (data, response, error) in
                
                if let data = data {
                    do {
                        let tests = try JSONDecoder().decode(Element.self, from: data)
                        completion(tests)
                    } catch Macchiato.TestError.error(let error) {
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
 
 
