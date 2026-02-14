//
//  APITarget.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

import Foundation

import Core

import Alamofire

protocol APITarget: URLRequestConvertible {
    var baseURL: URL { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var authorizationType: AuthorizationType { get }
    var task: RequestTask { get }
    
    func asURLRequest() throws -> URLRequest
}

extension APITarget {
    var baseURL: URL {
        guard let url = URL(string: URLConfiguration.baseURL) else {
            fatalError("[APITarget] URL 생성 실패 🙀")
        }
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        request.timeoutInterval = 10
        
        print("💌 REQUEST:", method.rawValue, endPoint)
        switch task {
        case .requestPlain:
            return request
        case let .requestQuery(encodable):
            printEncodable(encodable)
            return try URLEncodedFormParameterEncoder.default.encode(encodable, into: request)
        case let .requestBody(encodable):
            printEncodable(encodable)
            return try JSONParameterEncoder.default.encode(encodable, into: request)
        }
    }
    
    private func printEncodable(_ encodable: Encodable) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        
        if let prettyPrintedData = try? encoder.encode(encodable),
           let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
            print(prettyPrintedString)
        }
    }
}
