//
//  TermsAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 7/26/25.
//

import Foundation
import Alamofire

enum TermsAPI: TargetType {
    case getPencilShopAgreementStatus
    case postTermsAgreement(AddTermsAgreementRequest)

    var path: String {
        switch self {
        case .getPencilShopAgreementStatus:
            return "v2/terms-agreement/PENCIL_SHOP_SERVICE"
        case .postTermsAgreement:
            return "v2/terms-agreement"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPencilShopAgreementStatus:
            return .get
        case .postTermsAgreement:
            return .post
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
        case .postTermsAgreement(let param as Encodable):
            return param.toDictionary()
        default: return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

