//
//  STWFetcher.swift
//  Glamour
//
//  Created by Tal Zion on 21/03/2017.
//  Copyright © 2017 Stanwood GmbH. All rights reserved.
//

public typealias DataRESTResponse = (_ dataDictionary: Optional<[AnyHashable:Any]>, _ response: Optional<HTTPURLResponse>, _ error: Optional<Error>) throws -> Void

import Foundation

public enum HTTPMethods:String {
    case GET
    case POST
    case PUT
    case DELETE
}

public struct Header {
    let value:String
    let forHTTPHeaderField:String
}

open class STWFetcher {
    
    /**
     onComplition DictionaryRESTResponse = (dataDictionary: [String:AnyObject]?, response: NSHTTPURLResponse?, error: NSError?) -> Void
     */
    open static func getRequest(URL:URL, URLParams: [String:String]?, HTTPMethod method: HTTPMethods, headers: [Header]?, onComplition: @escaping DataRESTResponse) {
        
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a NSURLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        //"http://content.7nxt-api.com/v1/entries/de/mdkx/program/product_section"
        
        //MARK: - Setting URL
        var URL = URL
        
        var request = URLRequest(url: URL)
        request.httpMethod = method.rawValue
        
        if let params = URLParams {
            //MARK: - Paramaters
            
            URL = URL.URLByAppendingQueryParameters(params)
        }
        
        if let headers = headers {
            //MARK: - Headers
            
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.forHTTPHeaderField)
            }
        }
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            session.invalidateAndCancel()
            if error == nil {
                let statusResponse = response as! HTTPURLResponse
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyHashable:Any]
                    try! onComplition(dataDictionary, statusResponse, nil)
                } catch let error as NSError {
                    try! onComplition(nil, statusResponse, error)
                }
                
            } else {
                // Failure
                try! onComplition(nil, nil, error)
            }
        })
        task.resume()
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
