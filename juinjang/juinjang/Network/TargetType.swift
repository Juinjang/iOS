//
//  TargetType.swift
//  juinjang
//
//  Created by 강동영 on 2/24/25.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var parameters: [String: Any]? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        guard let url = createURL() else { throw NetworkError.invalidData }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var allHeaders: [String: String] = [:]
        header.forEach {
            allHeaders.updateValue($1, forKey: $0)
        }
        request.allHTTPHeaderFields = allHeaders
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
    
    func createURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL.appending(path))
        var items = [URLQueryItem]()
        
        if !queryItems.isEmpty {
            queryItems.forEach { items.append($0) }
            urlComponents?.queryItems = items
        }
        
        return urlComponents?.url
    }
}
