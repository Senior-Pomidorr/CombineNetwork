//
//  APIEndpoint.swift
//  CombineNetwork
//
//  Created by Daniil Kulikovskiy on 21.08.2025.
//

protocol APIEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var body: [String: Any] { get }
    var contentType: ContentType { get }
    var acceptType: ContentType { get }
}
