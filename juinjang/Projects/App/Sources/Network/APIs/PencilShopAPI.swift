//
//  PencilShopAPI.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

import Foundation
import Alamofire

enum PencilShopAPI: TargetType {
    case purchasePencil(PurchasePencilRequestDTO)
    case readPencil(ReadAcquiredPencilRequestDTO)
    case getUsedPencil
    case getPurchasedPencil
    case getAcquiredPencil
    case getIsTotalReadAcquiredPencil

    var path: String {
        switch self {
        case .purchasePencil:
            "v2/pencil/purchase/apple"
        case .readPencil:
            "v2/pencil/acquired/read"
        case .getUsedPencil:
            "v2/pencil/used"
        case .getPurchasedPencil:
            "v2/pencil/purchased"
        case .getAcquiredPencil:
            "v2/pencil/acquired"
        case .getIsTotalReadAcquiredPencil:
            "v2/pencil/acquired/is-total-read"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUsedPencil, .getPurchasedPencil, .getAcquiredPencil, .getIsTotalReadAcquiredPencil:
                .get
        case .purchasePencil:
                .post
        case .readPencil:
                .patch
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .purchasePencil(let param as Encodable),
                .readPencil(let param as Encodable):
                return param.toDictionary()
        default:
            return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

