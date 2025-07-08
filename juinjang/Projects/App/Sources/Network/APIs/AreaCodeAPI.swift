//
//  AreaCodeAPI.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import Foundation
import Alamofire

enum AreaCodeAPI: TargetType {
    
    case getAreaCodeSidoList(AreaCodeRequestDTO)
    case getAreaCodeSigunguList(AreaCodeRequestDTO)
    case getAreaCodeDongList(AreaCodeRequestDTO)
    
    var baseURL: BaseURLType {
        return .areaCode
    }
    
    var interceptor: AuthInterceptor? {
        return nil
    }

    var path: String {
        switch self {
        case .getAreaCodeSidoList:
            return "admCodeList"
        case .getAreaCodeSigunguList:
            return "admSiList"
        case .getAreaCodeDongList:
            return "admDongList"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAreaCodeSidoList, .getAreaCodeSigunguList, .getAreaCodeDongList:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getAreaCodeSidoList(let request),
                .getAreaCodeSigunguList(let request),
                .getAreaCodeDongList(let request):
            return request.toQueryItems()
        }
    }

    var parameters: [String : Any]? {
        return nil
    }
}


extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
