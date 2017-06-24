//
//  Service.swift
//  ServicePrototype
//
//  Created by Isaac Perry on 10/17/16.
//  Copyright © 2016 Isaac Perry. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public protocol Service {
    static var baseURL: String {get set}
}

extension Service {
    
//    public static func makeRequestForJson<U: JSONSerializable>(request: Request, handler: @escaping (U) -> Void) {
//        let urlRequest = getUrlRequest(request: request)
//        
//        Alamofire.request(urlRequest).responseString { response in
//            print(response.request ?? "Error in getting request")  // original URL request
//            print(response.response ?? "Error in getting response") // HTTP URL response
//            print(response.data ?? "Error in gettng data")     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//            try {
//                if let jsonString = response.result.value, let dataFromString = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false), let result = U(json: JSON(data: dataFromString)) {
//                    handler(result)
//                }
//            }
//        }
//        
//    }
    
    public static func makeRequestForString(request: Request, handler: @escaping (String) -> Void) {
        let urlRequest = getUrlRequest(request: request)
        
        Alamofire.request(urlRequest).responseString { response in
            print(response.request ?? "Error in getting request")  // original URL request
            print(response.response ?? "Error in getting response") // HTTP URL response
            print(response.data ?? "Error in gettng data")     // server data
            print(response.result)   // result of response serialization
            
            if let result = response.result.value {
                print("result: \(result)")
            }
            if let resultString = response.result.value, let dataFromString = resultString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                handler(resultString)
            }
        }
        
    }
    
    public static func makeRequestForJSON(request: Request, handler: @escaping (JSON) -> Void) {
        let urlRequest = getUrlRequest(request: request)
        
        Alamofire.request(urlRequest).responseString { response in
            print(response.request ?? "Error in getting request")  // original URL request
            print(response.response ?? "Error in getting response") // HTTP URL response
            print(response.data ?? "Error in gettng data")     // server data
            print(response.result)   // result of response serialization
            
            if let result = response.result.value {
                print("result: \(result)")
            }
            if let resultString = response.result.value,
                let dataFromString = resultString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    handler(json)
                } catch {
                    print("There was an error making a request")
                }
                
                
            }
        }
        
    }
    
    
    private static func getUrlRequest(request: Request) -> URLRequest {
        
        let url = URL(string: baseURL + request.path + request.getQueryString())!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                
            }
        }
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        return urlRequest
    }
}

public struct Request {
    var path: String
    var method: String
    var queryParams: [String:String]?
    var headers: [String:String]?
    var body: JSON?
    
    public init(path:String, method: String) {
        self.path = path
        self.method = method
    }
    
    public func getQueryString() -> String {
        var result = ""
        if let params = queryParams {
            var pairs = [String]()
            for (key, value) in params {
                pairs.append("\(key)=\(value)")
            }
            if pairs.count > 0 {
                result = "?" + pairs.joined(separator: "&")
            }
        }
        return result
    }
}

public protocol JSONSerializable {
    init?(json: JSON)
    var json: [String:Any] { get }
}


