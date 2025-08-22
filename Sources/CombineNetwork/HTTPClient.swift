// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

public final class HTTPClient {
    
    // MARK: - Session configuration
    let configuration = URLSessionConfiguration.default
    let session: URLSession
    
    public init() {
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Request
    @available(macOS 10.15, *)
    public func request<T: Codable>(endpoint: APIEndpoint, cachePolicy: URLRequest.CachePolicy? = .some(.useProtocolCachePolicy)) -> AnyPublisher<T, APIError> {
        
        guard let urlRequest = buildURLRequest(endpoint: endpoint, cachePolicy: cachePolicy) else {
            return Fail(error: APIError.unknown(statusCode: -1, message: "Failed to build URL request"))
                .eraseToAnyPublisher()
        }
        print(urlRequest)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .validateResponse()
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.unknown(statusCode: -1, message: error.localizedDescription)
                }
            })
            .eraseToAnyPublisher()
    }
    
     func buildURLRequest(endpoint: APIEndpoint, cachePolicy: URLRequest.CachePolicy? = .some(.useProtocolCachePolicy)) -> URLRequest? {
        var components = URLComponents()
         components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.host
        components.path = endpoint.path
        
        // Add query items if parameters exist
        if let queryItems = createQueryParameters(endpoint: endpoint) {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            print("Ошибка: Невозможно создать URL из компонентов: \(components)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let cachePolicy = cachePolicy {
            request.cachePolicy = cachePolicy
        }
        // Set headers if needed
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        // Set contentType and acceptType if needed
        request.setValue(endpoint.contentType.headerValue, forHTTPHeaderField: "Content-Type")
        request.setValue(endpoint.acceptType.headerValue, forHTTPHeaderField: "Accept")
        
        // Set http body if needed (for POST, PUT, etc.)
        if !endpoint.body.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: endpoint.body, options: [])
            } catch {
                print("Ошибка сериализации тела запроса: \(error)")
                return nil
            }
        }
        
        return request
    }
    
    private func createQueryParameters(endpoint: APIEndpoint) -> [URLQueryItem]? {
        guard let parameters = endpoint.parameters else { return nil }
        
        let queryItems: [URLQueryItem] = parameters.flatMap { key, value -> [URLQueryItem] in
            switch value {
            case let stringValue as String where !stringValue.isEmpty:
                return [URLQueryItem(name: key, value: stringValue)]
            case let intValue as Int:
                return [URLQueryItem(name: key, value: String(intValue))]
            case let stringArrayValue as [String]:
                return stringArrayValue.map { URLQueryItem(name: key, value: $0) }
            case let boolValue as Bool:
                return [URLQueryItem(name: key, value: String(boolValue))]
            default:
                return []
            }
        }
        
        return queryItems.isEmpty ? nil : queryItems
    }
}

@available(macOS 10.15, *)
extension Publisher where Output == (data: Data, response: URLResponse) {
    
    func validateResponse() -> AnyPublisher<Data, Error> {
        self.tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.badRequest(statusCode: -1, message: "Invalid response")
            }
            switch httpResponse.statusCode {
            case 400:
                throw APIError.badRequest(statusCode: httpResponse.statusCode, message: httpResponse.description)
            case 401:
                throw APIError.unauthorized(statusCode: httpResponse.statusCode, message: httpResponse.description)
            case 403:
                throw APIError.forbidden(statusCode: httpResponse.statusCode, message: httpResponse.description)
            case 404:
                throw APIError.notFound(statusCode: httpResponse.statusCode, message: httpResponse.description)
            case 500:
                throw APIError.internalServerError(statusCode: httpResponse.statusCode, message: httpResponse.description)
            case 200..<300:
                return data
            default:
                throw APIError.unknown(statusCode: httpResponse.statusCode, message: "Request failed with status code \(httpResponse.statusCode)")
            }
        }
        .eraseToAnyPublisher()
    }
}
