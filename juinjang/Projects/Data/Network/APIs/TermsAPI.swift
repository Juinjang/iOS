//
//  TermsAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 7/26/25.
//

import Foundation
import Alamofire

public enum TermsAPI: TargetType {
    case getPencilShopAgreementStatus
    case postTermsAgreement(TermsAgreementRequestDTO)

    public var path: String {
        switch self {
        case .getPencilShopAgreementStatus:
            return "v2/terms-agreement/PENCIL_SHOP_SERVICE"
        case .postTermsAgreement:
            return "v2/terms-agreement"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getPencilShopAgreementStatus:
            return .get
        case .postTermsAgreement:
            return .post
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
        case .postTermsAgreement(let param as Encodable):
            return param.toDictionary()
        default: return nil
        }
    }
    
    public var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

