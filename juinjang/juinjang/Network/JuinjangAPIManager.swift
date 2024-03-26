//
//  JuinjangAPIManager.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
import Alamofire
import UIKit

enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
}

final class JuinjangAPIManager {
    static let shared = JuinjangAPIManager()
    private init() { }
    
    func fetchData<T: Decodable>(type: T.Type, api: JuinjangAPI, completionHandler: @escaping (T?, NetworkError?) -> Void) {

        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameter,
                   headers: api.header)
       .responseDecodable(of: type) { response in
           switch response.result {
           case .success(let success):
               completionHandler(success, nil)
           case .failure(let failure):
               print(failure)
               completionHandler(nil, .failedRequest)
//               fatalError("네트워킹 오류")
           }
       }
    }
    
    func postData<T: Decodable>(type: T.Type, api: JuinjangAPI, parameter: [String:Any], completionHandler: @escaping (T?, NetworkError?) -> Void) {

        AF.request(api.endpoint,
                   method: api.method,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: api.header)
       .responseDecodable(of: type) { response in
           switch response.result {
           case .success(let success):
               completionHandler(success, nil)
           case .failure(let failure):
               print(failure)
               completionHandler(nil, .failedRequest)
//               fatalError("네트워킹 오류")
           }
       }
    }
    
    func postCheckListItem<T: Decodable>(type: T.Type, api: JuinjangAPI, parameters: [[String: Any]], completionHandler: @escaping (T?, NetworkError?) -> Void) {
        let parameters: Parameters? = parameters.isEmpty ? nil : ["data": parameters]

        AF.request(api.endpoint,
                   method: api.method,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: api.header)
        .responseDecodable(of: type) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success, nil)
            case .failure(let failure):
                print(failure)
                completionHandler(nil, .failedRequest)
            }
        }
    }
    
    func uploadImages(imjangId: Int, images: [UIImage], api: JuinjangAPI, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(imjangId)".data(using: .utf8)!, withName: "limjangId")
            for (index, image) in images.enumerated() {
                guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
                // "imgUrl" 키에 대한 배열 형식으로 이미지 데이터를 전송
                multipartFormData.append(imageData, withName: "images", fileName: "image\(index).jpeg", mimeType: "image/jpeg")
            }
        }, to: api.endpoint, method: api.method, headers: api.header)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                print(response)
                completion(.success(()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
}
