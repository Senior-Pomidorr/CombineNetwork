//
//  HttpMethod.swift
//  CombineNetwork
//
//  Created by Daniil Kulikovskiy on 21.08.2025.
//

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

public enum HTTPProtocol: String {
    case https = "https"
    case http = "http"
}


