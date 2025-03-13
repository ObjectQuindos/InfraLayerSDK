
import Foundation

/// Protocol to intercept before/after network calls.
public protocol Interceptor {
    
    /// Transform URLRequest before executing
    func prepare(request: URLRequest) -> URLRequest
    
    /// Invoked right before execution
    func willExecute(request: Request)
    
    /// Invoked right after execution
    func didExecute(request: Request)
    
    /// Called when `Request` was processed
    func process(response: Response)
}

public extension Interceptor {
    func prepare(request: URLRequest) -> URLRequest { return request }
    func willExecute(request: Request) {}
    func didExecute(request: Request) {}
    func process(response: Response) {}
}
