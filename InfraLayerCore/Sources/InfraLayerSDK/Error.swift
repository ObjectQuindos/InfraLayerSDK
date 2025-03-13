//
//  Error.swift
//  InfraLayerSDK

import Foundation

public struct HTTPError: Error {
    
    public let status: Status?
    public let message: JSON
    public let code: Code
    
    public enum Code {
        /// failed json parse
        case couldNotDecode(JSON)
        /// - status: 400
        case badRequest
        /// - status: 401
        case unauthorized
        /// - status: 402
        case paymentRequired
        /// - status: 403
        case forbidden
        /// - status: 404
        case notFound
        /// - status: 405
        case methodNotAllowed
        /// - status: 406
        case invalid
        /// - status: 407
        case proxyAuthRequest
        /// - status: 408
        case requestTimeout
        /// - status: 409
        case conflict
        /// - status: 410
        case gone
        /// - status: 411
        case lengthRequired
        /// - status: 412
        case preconditionFailed
        /// - status: 413
        case payloadTooLarge
        /// - status: 414
        case uriTooLong
        /// - status: 415
        case unsupportedMediaType
        /// - status: 416
        case rangeNotSatisfiable
        /// - status: 417
        case expectationFailed
        /// - status: 418
        case imATeapot
        /// - status: 421
        case misdirectRequest
        /// - status: 422
        case unprocessableEntity
        /// - status: 423
        case locked
        /// - status: 424
        case failedDependency
        /// - status: 426
        case upgradeRequired
        /// - status: 428
        case preconditionRequired
        /// - status: 429
        case tooManyRequest
        /// - status: 431
        case requestHeaderTooLarge
        /// - status: 451
        case unavailableForLegalReasons
        
        
        /// - status: 500
        case internalServerError
        /// - status: 501
        case notImplemented
        /// - status: 502
        case badGateway
        /// - status: 503
        case serviceUnavailable
        /// - status: 504
        case gatewayTimeout
        /// - status: 505
        case httpVersionNotSupported
        /// - status: 506
        case variantAlsoNegate
        /// - status: 507
        case insufficientStorage
        /// - status: 508
        case loopDetected
        /// - status: 510
        case notExtended
        /// - status: 511
        case networkAuthRequired
        
        /// Unknown
        case unknown
        /// other internal error
        case other(Error)
    }
    
    init(status: Int, message: JSON) {
        
        self.status = status
        self.message = message
        
        switch status {
        case 400: code = .badRequest
        case 401: code = .unauthorized
        case 402: code = .paymentRequired
        case 403: code = .forbidden
        case 404: code = .notFound
        case 405: code = .methodNotAllowed
        case 406: code = .invalid
        case 407: code = .proxyAuthRequest
        case 408: code = .requestTimeout
        case 409: code = .conflict
        case 410: code = .gone
        case 411: code = .lengthRequired
        case 412: code = .preconditionFailed
        case 413: code = .payloadTooLarge
        case 414: code = .uriTooLong
        case 415: code = .unsupportedMediaType
        case 416: code = .rangeNotSatisfiable
        case 417: code = .expectationFailed
        case 418: code = .imATeapot
        case 421: code = .misdirectRequest
        case 422: code = .unprocessableEntity
        case 423: code = .locked
        case 424: code = .failedDependency
        case 426: code = .upgradeRequired
        case 428: code = .preconditionRequired
        case 429: code = .tooManyRequest
        case 431: code = .requestHeaderTooLarge
        case 451: code = .unavailableForLegalReasons
            
        case 500: code = .internalServerError
        case 501: code = .notImplemented
        case 502: code = .badGateway
        case 503: code = .serviceUnavailable
        case 504: code = .gatewayTimeout
        case 505: code = .httpVersionNotSupported
        case 506: code = .variantAlsoNegate
        case 507: code = .insufficientStorage
        case 508: code = .loopDetected
        case 510: code = .notExtended
        case 511: code = .networkAuthRequired
            
        default:  code = .unknown
        }
    }
    
    init(error: Error) {
        status = nil
        message = [ "description": error.localizedDescription ]
        code = .other(error)
    }
    
    var localizedDescription: String {
        return message.stringify
    }
}

extension HTTPError.Code: Equatable {
    
    public static func == (lhs: HTTPError.Code, rhs: HTTPError.Code) -> Bool {
        switch (lhs, rhs) {
        case (.couldNotDecode, .couldNotDecode): return true
        case (.badRequest, .badRequest): return true
        case (.unauthorized, .unauthorized): return true
        case (.paymentRequired, .paymentRequired): return true
        case (.forbidden, .forbidden): return true
        case (.notFound, .notFound): return true
        case (.methodNotAllowed, .methodNotAllowed): return true
        case (.invalid, .invalid): return true
        case (.proxyAuthRequest, .proxyAuthRequest): return true
        case (.requestTimeout, .requestTimeout): return true
        case (.conflict, .conflict): return true
        case (.gone, .gone): return true
        case (.lengthRequired, .lengthRequired): return true
        case (.preconditionFailed, .preconditionFailed): return true
        case (.payloadTooLarge, .payloadTooLarge): return true
        case (.uriTooLong, .uriTooLong): return true
        case (.unsupportedMediaType, .unsupportedMediaType): return true
        case (.rangeNotSatisfiable, .rangeNotSatisfiable): return true
        case (.expectationFailed, .expectationFailed): return true
        case (.imATeapot, .imATeapot): return true
        case (.misdirectRequest, .misdirectRequest): return true
        case (.unprocessableEntity, .unprocessableEntity): return true
        case (.locked, .locked): return true
        case (.failedDependency, .failedDependency): return true
        case (.upgradeRequired, .upgradeRequired): return true
        case (.preconditionRequired, .preconditionRequired): return true
        case (.tooManyRequest, .tooManyRequest): return true
        case (.requestHeaderTooLarge, .requestHeaderTooLarge): return true
        case (.unavailableForLegalReasons, .unavailableForLegalReasons): return true
        case (.internalServerError, .internalServerError): return true
        case (.notImplemented, .notImplemented): return true
        case (.badGateway, .badGateway): return true
        case (.serviceUnavailable, .serviceUnavailable): return true
        case (.gatewayTimeout, .gatewayTimeout): return true
        case (.httpVersionNotSupported, .httpVersionNotSupported): return true
        case (.variantAlsoNegate, .variantAlsoNegate): return true
        case (.insufficientStorage, .insufficientStorage): return true
        case (.loopDetected, .loopDetected): return true
        case (.notExtended, .notExtended): return true
        case (.networkAuthRequired, .networkAuthRequired): return true
        case (.unknown, .unknown): return true
        case (.other, .other): return true
        default: return false
        }
    }
}
