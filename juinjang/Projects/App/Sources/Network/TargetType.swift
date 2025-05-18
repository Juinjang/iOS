//
//  TargetType.swift
//  juinjang
//
//  Created by 강동영 on 2/24/25.
//

import Foundation
import Alamofire
import RxSwift

protocol TargetType: URLRequestConvertible {
    var baseURL: BaseURLType { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var parameters: [String: Any]? { get }
    var interceptor: AuthInterceptor? { get }
}

extension TargetType {
    var header: [String : String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
        ]
    }
    
    var baseURL: BaseURLType {
        return .juinjang
    }
    
    var interceptor: AuthInterceptor? {
        return nil
    }
    
    func request<T: Decodable>(_ type: T.Type,
                               _ provider: JuinjangAPIManager) -> Single<T> {
        return provider.fetchData<T>(api: self, interceptor: interceptor)
    }
    
    func createURL() -> URL? {
        var components = URLComponents(string: baseURL.url + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = createURL() else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header

        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }

        return request
    }
}
