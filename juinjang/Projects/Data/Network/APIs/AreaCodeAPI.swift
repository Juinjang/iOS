//
//  AreaCodeAPI.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import Foundation
import Alamofire
import CoreCommon

public enum AreaCodeAPI: TargetType {
    case getAreaCodeSidoList(AreaCodeRequestDTO)
    case getAreaCodeSigunguList(AreaCodeRequestDTO)
    case getAreaCodeDongList(AreaCodeRequestDTO)
    
    public var baseURL: BaseURLType {
        return .areaCode
    }
    
    public var interceptor: AuthInterceptor? {
        return nil
    }

    public var path: String {
        switch self {
        case .getAreaCodeSidoList:
            return "admCodeList"
        case .getAreaCodeSigunguList:
            return "admSiList"
        case .getAreaCodeDongList:
            return "admDongList"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getAreaCodeSidoList, .getAreaCodeSigunguList, .getAreaCodeDongList:
            return .get
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .getAreaCodeSidoList(let request),
                .getAreaCodeSigunguList(let request),
                .getAreaCodeDongList(let request):
            return request.toQueryItems()
        }
    }

    public var parameters: [String : Any]? {
        return nil
    }
}


extension Encodable {
    public var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
