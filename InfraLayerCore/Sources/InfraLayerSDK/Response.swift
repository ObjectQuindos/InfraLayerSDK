
import Foundation

public struct Response {
    
    public let request: Request
    public let status: Status
    public let header: Headers
    public let data: Data?
    
    init?(with request: Request, response: URLResponse?, data: Data?) {
        
        guard
            let response = response as? HTTPURLResponse,
            let header = response.allHeaderFields as? Headers
                
        else { return nil }
        
        self.request = request
        self.status = response.statusCode
        self.header = header
        self.data = data
    }
    
    public var JSON: JSON {
        Parser.transformer(data) ?? [:]
    }
    
    public var plain: String {
        Parser.transformer(data) ?? ""
    }
}

extension Response: CustomStringConvertible {
    
    public var description: String {
        var components: [String] = []
        
        if let httpMethod = request.request.httpMethod {
            components.append(httpMethod)
        }
        
        if let urlString = request.request.url?.absoluteString {
            components.append(urlString)
        }
        
        components.append("(\(status)")
        
        if let data = data,
           let text = String(data: data, encoding: .utf8),
           JSON.isEmpty {
            components.append(text)
            
        } else {
            components.append("\(JSON)")
        }
        
        return components.joined(separator: " ")
    }
}

public enum Result<T> {
    
    case success(T)
    case failure(HTTPError)
    
    init(value: T) {
        self = .success(value)
    }
    
    init(error: HTTPError) {
        self = .failure(error)
    }
}
