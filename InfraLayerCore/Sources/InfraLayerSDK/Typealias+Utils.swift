//
//  Typealias+Utils.swift
//  InfraLayerSDK
//

import Foundation

public typealias Status = Int
public typealias JSON = [ String: Any ]

typealias HTTPResponse = (data: Data?, response: URLResponse?, error: Error?)
public typealias ResponseHandler = Result<Response>
typealias TaskClosure = (ResponseHandler) -> Void
public typealias PlainResponse = Result<String>
public typealias JSONResponse = Result<JSON>
public typealias DataResponse = Result<Data?>

public typealias RawValue = String
public typealias Headers = [ String : String ]
public typealias Parameters = [ String : Any? ]
public typealias Identifier = String

public enum Parser {
    
    static func transformer(_ data: Data?) -> JSON? {
        guard
            let data,
            let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
                
        else { return nil }
        
        return object
    }
    
    static func transformer(_ data: Data?) -> String? {
        guard let data else { return nil }
        return String(bytes: data, encoding: .utf8)
    }
}

extension Dictionary where Key == String, Value == Any {
    
    var stringify: String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
}
