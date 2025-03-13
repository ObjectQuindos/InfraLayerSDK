
import Foundation

public struct CommonHeaders {
    
    let appVersion: String?
    let deviceToken: String?
    
    public init(appVersion: String? = nil, deviceToken: String? = nil) {
        self.appVersion = appVersion
        self.deviceToken = deviceToken
    }
}

extension CommonHeaders: Interceptor {
    
    public func prepare(request: URLRequest) -> URLRequest {
        
        var headersRequest = request
        
        if let appVersion {
            headersRequest.setValue(appVersion, forHTTPHeaderField: "X-Habit-AppVersion")
        }
        
        if let deviceToken {
            headersRequest.setValue(deviceToken, forHTTPHeaderField: "X-Habit-DeviceToken")
        }
        
        return headersRequest
    }
}
