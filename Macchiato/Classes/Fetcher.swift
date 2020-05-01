//
//  Fetcher.swift
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

typealias DataResponse = (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void

import Foundation

extension Macchiato {
    
    enum HTTPMethods:String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    struct Header {
        let value:String
        let forHTTPHeaderField:String
    }
    
    class Fetcher {
        
        private init () {}
        /**
         onComplition DictionaryRESTResponse = (dataDictionary: [String:AnyObject]?, response: NSHTTPURLResponse?, error: NSError?) -> Void
         */
        static func sendRequest(with url: URL, URLParams: [String:String]?, HTTPMethod method: HTTPMethods, headers: [Header]?, body: Data?, onCompletion: @escaping DataResponse) {
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            //MARK: - Setting URL
            var URL = url
            if let params = URLParams {
                //MARK: - Paramaters
                
                URL = URL.URLByAppendingQueryParameters(params)
            }
            
            var request = URLRequest(url: URL)
            request.httpMethod = method.rawValue
            
            
            if let headers = headers {
                headers.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.forHTTPHeaderField) })
            }
            
            /// Body
            request.httpBody = body
            
            /* Start a new Task */
            let task = session.dataTask(with: request, completionHandler: {
                data, response, error in
                onCompletion(data, response as? HTTPURLResponse, error)
            })
            task.resume()
            session.finishTasksAndInvalidate()
        }
    }
}
protocol URLQueryParameterStringConvertible {
    var queryParameters: String { get }
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = NSString(format: "%@=%@",
                                String(describing: key).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                                String(describing: value).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new NSURL.
     */
    func URLByAppendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : NSString = NSString(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString as String)!
    }
    
}
