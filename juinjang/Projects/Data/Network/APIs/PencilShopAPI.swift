//
//  PencilShopAPI.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

import Foundation
import Alamofire

public enum PencilShopAPI: TargetType {
    case getPencilBalance
    case purchasePencil(PurchasePencilRequestDTO)
    case readPencil(acquiredPencilId: Int)
    case getUsedPencil
    case getPurchasedPencil
    case getAcquiredPencil
    case getIsTotalReadAcquiredPencil

    public var path: String {
        switch self {
        case .getPencilBalance:
            "v2/pencil-account/balance"
        case .purchasePencil:
            "v2/pencil/purchase/apple"
        case .readPencil(let acquiredPencilId):
            "v2/pencil/acquired/\(acquiredPencilId)/read"
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

    public var method: HTTPMethod {
        switch self {
        case .getPencilBalance, .getUsedPencil, .getPurchasedPencil, .getAcquiredPencil, .getIsTotalReadAcquiredPencil:
                .get
        case .purchasePencil:
                .post
        case .readPencil:
                .patch
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .purchasePencil(let param as Encodable):
                return param.toDictionary()
        default:
            return nil
        }
    }
    
    public var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

