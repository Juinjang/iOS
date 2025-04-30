//
//  NetworkProvider.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift
import Alamofire
import Foundation

final class NetworkProvider<T: TargetType> {
    static var provider: NetworkProvider<T> {
        return NetworkProvider<T>()
    }
    
    func request(_ target: T) -> Single<Data> {
        return Single.create { single in
            guard let url = target.createURL() else {
                single(.failure(NetworkError.invalidUrl))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = target.method.rawValue
            request.allHTTPHeaderFields = target.header
            
            if let parameters = target.parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                if let data = data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 Response Body:\n\(jsonString)")
                } else {
                    print("⚠️ Empty or non-UTF8 data")
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    single(.failure(URLError(.badServerResponse)))
                    return
                }
                
                single(.success(data))
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
