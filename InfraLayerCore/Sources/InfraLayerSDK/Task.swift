
import Foundation

public protocol Task {
    
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: Headers { get }
    var parameters: Parameters { get }
    var listOfParameters: [Parameters]? { get }
    var encoding: Encoding { get }
    var dataEncode: Data? { get }
    var isMultipartDataEnconde: Bool { get }
    
    var id: Identifier { get }
}

public extension Task {
    
    var id: Identifier {
        method.rawValue + path + parameters.description
    }
    
    var method: HTTPMethod { .get }
    
    var queryItems: [URLQueryItem]? { return nil }
    var headers: Headers { [:] }
    
    var parameters: Parameters { [:] }
    var listOfParameters: [Parameters]? { nil }
    
    var encoding: Encoding { JSONEncoding.default }
    var dataEncode: Data? { return nil }
    
    var isMultipartDataEnconde: Bool { return false }
    
    func request(with baseURL: URL) -> URLRequest {
        let url = setURL(with: baseURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.networkServiceType = .responsiveData
        request.allHTTPHeaderFields = headers
        setHttpBody(request: &request)
        
        return request
    }
    
    private func setURL(with baseURL: URL) -> URL? {
        var url = URL(string: "")
        
        if #available(iOS 16.0, *) {
            url = baseURL.appending(path: path)
        } else {
            url = baseURL.appendingPathComponent(path)
        }
        
        if let items = queryItems {
            var urlComponents = URLComponents(string: url?.absoluteString ?? "")
            urlComponents?.queryItems = items
            let url = urlComponents?.url
            
            return url
        }
        
        return url
    }
    
    private func setHttpBody(request: inout URLRequest) {
        
        if dataEncode == nil { // httpbody: JSON - [JSON]
            
            if listOfParameters != nil {
                request = encoding.encode(request: request, with: listOfParameters ?? [])
                
            } else {
                request = encoding.encode(request: request, with: parameters)
            }
            
        } else { // httpbody: Data
            request.httpBody = dataEncode
            
            if isMultipartDataEnconde {
                
            } else {
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
        }
    }
}
