//
//  TargetType.swift
//  juinjang
//
//  Created by 강동영 on 2/24/25.
//

import Foundation
import Alamofire
import RxSwift
import DataStorage

public protocol TargetType: URLRequestConvertible {
    var baseURL: BaseURLType { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var parameters: [String: Any]? { get }
    var bodyData: Data? { get }
    var interceptor: AuthInterceptor? { get }
}

extension TargetType {
    public var header: [String : String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
        ]
    }
    
    public var baseURL: BaseURLType {
        return .juinjang
    }
    
    public var interceptor: AuthInterceptor? {
        return nil
    }
    
    public var bodyData: Data? {
        return nil
    }
    
    public func request<T: Decodable>(_ type: T.Type,
                               _ provider: JuinjangAPIManager) -> Single<T> {
        return provider.fetchData<T>(api: self, interceptor: interceptor)
    }
    
    public func createURL() -> URL? {
        var components = URLComponents(string: baseURL.url + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
    
    public func asURLRequest() throws -> URLRequest {
        guard let url = createURL() else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        
        if let data = bodyData {
            request.httpBody = data
        } else if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }

        return request
    }
}
