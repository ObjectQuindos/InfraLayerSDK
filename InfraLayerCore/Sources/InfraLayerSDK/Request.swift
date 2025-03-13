
import Foundation

public final class Request {
    
    let id: Identifier
    let request: URLRequest
    var state: State
    var completion: [TaskClosure]
    
    private weak var session: Session?
    private weak var queue: Queue?
    
    private var task: URLSessionTask?
    
    init(id: Identifier, request: URLRequest, session: Session, queue: Queue, completion: @escaping (TaskClosure)) {
        
        self.id = id
        self.request = request
        self.state = .pending
        self.completion = [completion]
        
        self.session = session
        self.queue = queue
    }
    
    func add(closure: @escaping (TaskClosure)) {
        completion.append(closure)
    }
    
    func execute() {
        if case .running = state { return }
        
        task = session?.task(with: request, completion: { [weak self] response in
            guard let self else { return }
            print(request.allHTTPHeaderFields)
            self.state = .finished
            self.queue?.process(request: self, response: response)
        })
        
        task?.resume()
        state = .running
    }
    
    func pause() {
        task?.suspend()
        state = .pause
    }
    
    func stop() {
        task?.cancel()
        state = .finished
    }
}

extension Request {
    
    public enum State {
        case pending
        case running
        case pause
        case failed
        case finished
    }
}

extension Request: Equatable/*, Hashable*/ {
    
    /*public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }*/
    
    public static func == (lhs: Request, rhs: Request) -> Bool {
        lhs.id == rhs.id
    }
}

extension Request: CustomStringConvertible {
    
    public var description: String {
        var components: [String] = []
        
        if let httpMethod = request.httpMethod {
            components.append(httpMethod)
        }
        
        if let urlString = request.url?.absoluteString {
            components.append(urlString)
        }
        
        return components.joined(separator: " ")
    }
}
