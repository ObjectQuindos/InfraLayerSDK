
import Foundation

private let kiloBytes = 1024
private let megaBytes = 1024 * kiloBytes

public final class Session {
    
    private let baseURL: URL
    private let session: URLSession
    
    init(with url: URL, session: URLSession) {
        baseURL = url
        self.session = session
    }
    
    convenience init(with url: URL) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 10 * megaBytes, diskCapacity: 50 * megaBytes, diskPath: nil)
        configuration.httpAdditionalHeaders = Session.defaultHTTPHeaders
        let session = URLSession(configuration: configuration)
        self.init(with: url, session: session)
    }
    
    func request<T: APITask>(with task: T) -> URLRequest {
        return task.request(with: baseURL)
    }
    
    func task(with request: URLRequest, completion: @escaping (HTTPResponse) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            completion((data: data, response: response, error: error))
        }
    }
}

private extension Session {
    
    // MARK: - User-Agent
    
    static let defaultHTTPHeaders: Headers = {
        guard
            let info = Bundle.main.infoDictionary
        else {
            return [ "User-Agent": "Edge" ]
        }
        
        let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
        let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
        let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
        let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
        
        let osNameVersion: String = {
            let osName: String = {
                #if os(iOS)
                    return "iOS"
                #elseif os(watchOS)
                    return "watchOS"
                #elseif os(tvOS)
                    return "tvOS"
                #elseif os(macOS)
                    return "macOS"
                #elseif os(Linux)
                    return "Linux"
                #else
                    return "Unknown"
                #endif
            }()
            
            let osVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            }()
            
            return "\(osName) \(osVersion)"
        }()
        
        let edgeVersion: String = {
            /*guard
                //let edgeInfo = Bundle(for: Edge.self).infoDictionary,
                //let edgeBuild = edgeInfo["CFBundleShortVersionString"]
            else {
                return "Unknown"
            }*/
            let edgeBuild = "mock"
            return "NetworkEdgeKit/\(edgeBuild)"
        }()
        
        return [
            "User-Agent": "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(edgeVersion)"
        ]
    }()
}
