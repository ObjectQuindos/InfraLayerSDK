
import Foundation

public enum HTTPMethod {
    
    case get
    case post
    case put
    case patch
    case delete
    
    case head
    case connect
    case options
    case trace
    
    public init?(rawValue: RawValue) {
        
        switch rawValue {
        case HTTPMethod.get.rawValue:
            self = .get
        case HTTPMethod.post.rawValue:
            self = .post
        case HTTPMethod.put.rawValue:
            self = .put
        case HTTPMethod.patch.rawValue:
            self = .patch
        case HTTPMethod.delete.rawValue:
            self = .delete
        case HTTPMethod.head.rawValue:
            self = .head
        case HTTPMethod.connect.rawValue:
            self = .connect
        case HTTPMethod.options.rawValue:
            self = .options
        case HTTPMethod.trace.rawValue:
            self = .trace
        default: return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        case .connect: return "CONNECT"
        case .options: return "OPTIONS"
        case .trace: return "TRACE"
        }
    }
}

extension URLRequest {
    
    var method: HTTPMethod {
        HTTPMethod(rawValue: httpMethod ?? "GET") ?? .get
    }
}
