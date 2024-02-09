//
//  File.swift
//  juinjang
//
//  Created by 박도연 on 2/8/24.
//
import Foundation
import Alamofire

enum JuinjangAPI {
    case kakaoLogin
    var baseURL: String {
        return "http://juinjang1227.com:8080/api"
    }
    var endpoint: URL {
        switch self {
        case .kakaoLogin: return URL(string: baseURL + "/auth/kakao")!
        }
    }
}

func requestPOST() {
    var urlComponents = URLComponents(string: "http://juinjang1227.com:8080/api/auth/kakao")
    let paramQuery_1 = URLQueryItem(name: "message", value: "1")
    urlComponents?.queryItems?.append(paramQuery_1)
    
    //var requestURL = URLRequest(url: (urlComponents?.url)!)
}
