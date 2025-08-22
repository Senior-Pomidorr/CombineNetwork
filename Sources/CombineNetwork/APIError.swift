//
//  File.swift
//  CombineNetwork
//
//  Created by Daniil Kulikovskiy on 21.08.2025.
//

import Foundation

public enum APIError: Error, LocalizedError {
    case badRequest(statusCode: Int, message: String)
    case unauthorized(statusCode: Int, message: String)
    case forbidden(statusCode: Int, message: String)
    case notFound(statusCode: Int, message: String)
    case internalServerError(statusCode: Int, message: String)
    case unknown(statusCode: Int, message: String)
    
    init(statusCode: Int, message: String) {
        switch statusCode {
        case 400:
            self = .badRequest(statusCode: statusCode, message: message)
        case 401:
            self = .unauthorized(statusCode: statusCode, message: message)
        case 403:
            self = .forbidden(statusCode: statusCode, message: message)
        case 404:
            self = .notFound(statusCode: statusCode, message: message)
        case 500:
            self = .internalServerError(statusCode: statusCode, message: message)
        default:
            self = .unknown(statusCode: statusCode, message: message)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .badRequest(let statusCode, _),
                .unauthorized(let statusCode, _),
                .forbidden(let statusCode, _),
                .notFound(let statusCode, _),
                .internalServerError(let statusCode, _),
                .unknown(let statusCode, _):
            return statusCode
        }
    }
}

