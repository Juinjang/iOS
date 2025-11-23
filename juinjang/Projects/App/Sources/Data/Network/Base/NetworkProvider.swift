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
            
            AF.request(
                url,
                method: target.method,
                parameters: target.parameters,
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(target.header),
                interceptor: AuthInterceptor()
            ).responseData { response in
                switch response.result {
                case .success(let data):
                    if let json = String(data: data, encoding: .utf8) {
                        print("📦 Response JSON:\n\(json)")
                    }
                    single(.success(data))
                case .failure(let error):
                    print("❌ Alamofire Error: \(error)")
                    single(.failure(NetworkError.failedRequest))
                }
            }
            
            return Disposables.create()
        }
    }
}
