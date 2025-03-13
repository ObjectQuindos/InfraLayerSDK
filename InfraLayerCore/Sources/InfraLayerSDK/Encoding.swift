//
//  Encoding.swift
//  InfraLayerSDK
//

import Foundation

/// Protocol for encoding an `URLRequest` with `Parameters` and modify the `URLRequest` `Content-Type`
public protocol Encoding {
    
    /// Transforms an `URLRequest` with `Parameters` to other `URLRequest`
    func encode(request: URLRequest, with parameters: Parameters) -> URLRequest
    
    /// Transforms an `URLRequest` with `List of Parameters` to other `URLRequest`
    func encode(request: URLRequest, with parameters: [Parameters]) -> URLRequest
}

/// Definition for `JSON` encoded requests
public struct JSONEncoding: Encoding {
    
    /// Default `JSONEncoding` for `Task`
    public static var `default`: JSONEncoding { JSONEncoding() }
    
    /// Add parameters on http body
    public func encode(request: URLRequest, with parameters: Parameters) -> URLRequest {
        var encodedRequest = request
        
        if !parameters.isEmpty {
            encodedRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        encodedRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return encodedRequest
    }
    
    public func encode(request: URLRequest, with parameters: [Parameters]) -> URLRequest {
        var encodedRequest = request
        
        if !parameters.isEmpty {
            encodedRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        encodedRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return encodedRequest
    }
}

/// Definition for `URL` encoded requests
public struct URLEncoding: Encoding {

    /// Default `URLEncoding` for `Task`
    public static var `default`: URLEncoding { URLEncoding() }
    
    /// Add parameters as query params
    public func encode(request: URLRequest, with parameters: Parameters) -> URLRequest {
        var encodedRequest = request
        
        guard
            let url = request.url,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            fatalError("Unable to create URL components from \(String(describing: request.url))")
        }
        
        if !parameters.isEmpty {
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String(describing: $1))
            }
        }
        
        switch request.method {
        case .get:
            encodedRequest.url = components.url
        default:
            encodedRequest.httpBody = components.query?.data(using: .utf8, allowLossyConversion: false)
            encodedRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        return encodedRequest
    }
    
    // NOTE: NOT USED
    public func encode(request: URLRequest, with parameters: [Parameters]) -> URLRequest {
        let encodedRequest = request
        return encodedRequest
    }
}
