//
//  Authorization.swift
//  InfraLayerSDK
//

import Foundation

public struct Authorization {
    
    let scheme: Scheme
    let token: String
    
    public enum Scheme: String {
        case None
        case Basic
        case Bearer
        case JWT
    }
    
    public init(scheme: Scheme, token: String) {
        self.scheme = scheme
        self.token = token
    }
    
    var serialize: String {
        return scheme.serialize + token
    }
}

private extension Authorization.Scheme {
    
    var serialize: String {
        switch self {
        case .None: return ""
        case .Basic, .Bearer, .JWT: return rawValue + " "
        }
    }
}

extension Authorization: Interceptor {
    
    public func prepare(request: URLRequest) -> URLRequest {
        var authorizationRequest = request
        authorizationRequest.setValue(serialize, forHTTPHeaderField: "Authorization")
        return authorizationRequest
    }
}
