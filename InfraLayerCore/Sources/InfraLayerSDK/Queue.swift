
import Foundation

public final class Queue {
    
    private let queue: DispatchQueue
    private static let defaultQueue = DispatchQueue(label: "com.edge.queue")
    private var requests: [Request]
    private var interceptors: [Interceptor]
    
    private(set) var isStopped = true
    
    init(queue: DispatchQueue = Queue.defaultQueue, requests: [Request] = [], interceptors: [Interceptor] = []) {
        self.queue = queue
        self.requests = requests
        self.interceptors = interceptors
    }
    
    // MARK: - Interceptors
    
    func add(interceptor: Interceptor) {
        interceptors.append(interceptor)
    }
    
    func removeInterceptors() {
        interceptors.removeAll()
    }
    
    func prepare(request: URLRequest) -> URLRequest {
        return interceptors.reduce(request) { partialResult, interceptor in
            interceptor.prepare(request: partialResult)
        }
    }
    
    // MARK: - Requests
    
    func enqueue(request: Request) {
        queue.sync {
            if let response = request.completion.first,
               let index = requests.firstIndex(of: request) {
                requests[index].add(closure: response)
                
            } else {
                requests.append(request)
                execute(request)
            }
        }
    }
    
    func remove(request: Request) {
        queue.sync {
            guard let index = requests.firstIndex(of: request) else { return }
            requests.remove(at: index)
        }
    }
    
    func start() {
        isStopped = false
        requests.forEach { $0.execute() }
    }
    
    func stop() {
        isStopped = false
        requests.forEach { $0.pause() }
    }
    
    func flush() {
        requests.forEach { $0.stop() }
        requests.removeAll()
    }
    
    // MARK: - Requests Process
    
    func process(request: Request, response: HTTPResponse) {
        
        interceptors.forEach { $0.didExecute(request: request) }
        
        request.completion.forEach { [weak self] closure in
            let result: ResponseHandler
            
            if let error = response.error {
                result = .failure(HTTPError(error: error))
                request.state = .failed
                
            } else {
                guard let httpResponse = Response(with: request, response: response.response, data: response.data)
                
                else { print("Could not get HTTP response"); return }
                
                if 200 ..< 300 ~= httpResponse.status {
                    result = .success(httpResponse)
                    
                } else {
                    let error = HTTPError(status: httpResponse.status, message: httpResponse.JSON)
                    result = .failure(error)
                    request.state = .failed
                }
                
                self?.interceptors.forEach { $0.process(response: httpResponse) }
            }
            
            closure(result)
        }
        
        remove(request: request)
    }
    
    private func execute(_ request: Request) {
        if isStopped { return }
        
        switch request.state {
            
        case .pending, .failed:
            interceptors.forEach { $0.willExecute(request: request) }
            request.execute()
            
        case .finished:
            remove(request: request)
            
        case .running, .pause: break
        }
    }
}
