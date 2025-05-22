//
//  AreaAPI.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import Foundation
import Alamofire

enum AreaAPI: TargetType {
    
    case getAdmSidoList(AdmRequestDTO)
    case getAdmSigunguList(AdmRequestDTO)
    case getAdmDongList(AdmRequestDTO)
    
    var baseURL: BaseURLType {
        return .lawDistrict
    }
    
    var interceptor: AuthInterceptor? {
        return nil
    }

    var path: String {
        switch self {
        case .getAdmSidoList:
            return "admCodeList"
        case .getAdmSigunguList:
            return "admSiList"
        case .getAdmDongList:
            return "admDongList"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAdmSidoList, .getAdmSigunguList, .getAdmDongList:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getAdmSidoList(let request),
                .getAdmSigunguList(let request),
                .getAdmDongList(let request):
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
