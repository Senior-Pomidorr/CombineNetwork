//
//  ContentType.swift
//  CombineNetwork
//
//  Created by Daniil Kulikovskiy on 21.08.2025.
//

public enum ContentType {
    case json
    case jsonPatch
    case formURLEncoded
    case multipartFormData
    case xml
    case plainText
    case custom(String)
    
    public var headerValue: String {
        switch self {
        case .json:
            return "application/json"
        case .jsonPatch:
            return "application/json-patch+json"
        case .formURLEncoded:
            return "application/x-www-form-urlencoded"
        case .multipartFormData:
            return "multipart/form-data"
        case .xml:
            return "application/xml"
        case .plainText:
            return "text/plain"
        case .custom(let stringValue):
            return stringValue
        }
    }
    
}
