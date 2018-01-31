//
//  Fetcher.swift
//  UITesting
//
//  Created by Tal Zion on 21/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

typealias DataResponse = (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void

import Foundation

extension UITesting {
    
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
