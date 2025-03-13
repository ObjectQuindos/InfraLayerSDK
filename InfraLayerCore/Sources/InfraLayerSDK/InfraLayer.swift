// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class InfraLayer {
    
    // MARK: - Properties
    
    private let session: Session
    private let queue: Queue
    
    // MARK: - Inits
    
    public init(session: Session, queue: Queue) {
        self.session = session
        self.queue = queue
        start()
    }
    
    public convenience init(with url: URL) {
        let session = Session(with: url)
        let queue = Queue()
        self.init(session: session, queue: queue)
    }
    
    public convenience init(baseURL: String) {
        guard let url = URL(string: baseURL) else { fatalError() }
        self.init(with: url)
    }
    
    // MARK: - Runtime
    
    public func start() {
        if queue.isStopped {
            queue.start()
        }
    }
    
    public func stop() {
        queue.stop()
    }
    
    public func reset() {
        removeInterceptors()
        queue.flush()
    }
    
    // MARK: - Interceptors
    
    public func add(interceptor: Interceptor) {
        queue.add(interceptor: interceptor)
    }
    
    public func removeInterceptors() {
        queue.removeInterceptors()
    }
    
    // MARK: - Execute
    
    // String Response
    public func request<T: APITask>(_ task: T, completion: @escaping ((PlainResponse) -> Void)) {
        
        execute(task) { result in
            
            switch result {
                
            case .success(let response):
                completion(.success(response.plain))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // JSON Response
    public func request<T: APITask>(_ task: T, completion: @escaping ((JSONResponse) -> Void)) {
        
        execute(task) { result in
            
            switch result {
                
            case .success(let response):
                completion(.success(response.JSON))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Data Response
    public func request<T: APITask>(_ task: T, completion: @escaping ((DataResponse) -> Void)) {
        
        execute(task) { result in
            
            switch result {
                
            case .success(let response):
                completion(.success(response.data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // ResponseHandler Response
    public func request<T: APITask>(_ task: T, completion: @escaping ((ResponseHandler) -> Void)) {
        
        execute(task) { result in
            
            switch result {
                
            case .success(let response):
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func execute<T: APITask>(_ task: T, completion: @escaping (TaskClosure)) {
        let url = queue.prepare(request: session.request(with: task))
        let request = Request(id: task.id, request: url, session: session, queue: queue, completion: completion)
        queue.enqueue(request: request)
    }
}
