//
//  JuinjangError.swift
//  Domain
//
//  Created by 조유진 on 2/14/26.
//

// 임시 Error 데이터
public enum JuinjangError: Error {
    case VALIDATION_ERROR(message: String? = nil)
    case WRONG_VALUE(message: String? = nil)
    case NOT_FOUND(message: String? = nil)
    case AUTH_REQUIRED(message: String? = nil)
    case ACCESS_DENIED(message: String? = nil)
    case DUPLICATE_KEY(message: String? = nil)
    case FK_CONFLICT_DELETE(message: String? = nil)
    case FK_REF_NOT_FOUND(message: String? = nil)
    case NOT_NULL_VIOLATION(message: String? = nil)
    case DATA_TOO_LONG(message: String? = nil)
    case CHECK_CONSTRAINT(message: String? = nil)
    case DATA_INTEGRITY_VIOLATION(message: String? = nil)
    case ACCESS_TOKEN_NOT_VALID(message: String? = nil)
    case ACCESS_TOKEN_EXPIRED(message: String? = nil)
    case REFRESH_TOKEN_PEER_NOT_MATCHED(message: String? = nil)
    case REFRESH_TOKEN_USER_NOT_MATCHED(message: String? = nil)
    case REFRESH_TOKEN_EXPIRED(message: String? = nil)
    case REFRESH_TOKEN_NOT_VALID(message: String? = nil)
    case ACCESS_TOKEN_ISSUED_DATE_NOT_MATCHED(message: String? = nil)
    case BUSINESS_ERROR(message: String? = nil)
    case EXTERNAL_HTTP_CLIENT_ERROR(message: String? = nil)
    case INTERNAL_ERROR(message: String? = nil)
    
    case CLIENT_ERROR(message: String? = nil)
    case REISSUE_FAILED(message: String? = nil)
    
    public var description: String {
        switch self {
        case .VALIDATION_ERROR(let message), .WRONG_VALUE(let message), .NOT_FOUND(let message),
                .AUTH_REQUIRED(let message), .ACCESS_DENIED(let message),
                .DUPLICATE_KEY(let message), .FK_CONFLICT_DELETE(let message),
                .FK_REF_NOT_FOUND(let message), .NOT_NULL_VIOLATION(let message),
                .DATA_TOO_LONG(let message), .CHECK_CONSTRAINT(let message),
                .DATA_INTEGRITY_VIOLATION(let message), .ACCESS_TOKEN_NOT_VALID(let message),
                .ACCESS_TOKEN_EXPIRED(let message), .REFRESH_TOKEN_PEER_NOT_MATCHED(let message),
                .REFRESH_TOKEN_USER_NOT_MATCHED(let message), .REFRESH_TOKEN_EXPIRED(let message),
                .REFRESH_TOKEN_NOT_VALID(let message), .ACCESS_TOKEN_ISSUED_DATE_NOT_MATCHED(let message),
                .BUSINESS_ERROR(let message), .EXTERNAL_HTTP_CLIENT_ERROR(let message),
                .INTERNAL_ERROR(let message), .CLIENT_ERROR(let message):
            return "\(message ?? userFriendlyMessage)"
            
        case .REISSUE_FAILED:
            return "세션이 만료되었습니다.\n다시 로그인해 주세요."
        }
    }
}

extension JuinjangError {
    public init(code: String, message: String? = nil) {
        switch code {
        case "1000":  self = .VALIDATION_ERROR(message: message)
        case "1001":  self = .WRONG_VALUE(message: message)
        case "1002":  self = .NOT_FOUND(message: message)
        case "1003":  self = .AUTH_REQUIRED(message: message)
        case "1004":  self = .ACCESS_DENIED(message: message)
        case "1005":  self = .DUPLICATE_KEY(message: message)
        case "1006":  self = .FK_CONFLICT_DELETE(message: message)
        case "1007":  self = .FK_REF_NOT_FOUND(message: message)
        case "1008":  self = .NOT_NULL_VIOLATION(message: message)
        case "1009":  self = .DATA_TOO_LONG(message: message)
        case "1010":  self = .CHECK_CONSTRAINT(message: message)
        case "1011":  self = .DATA_INTEGRITY_VIOLATION(message: message)
        case "1017":  self = .ACCESS_TOKEN_NOT_VALID(message: message)
        case "1018":  self = .ACCESS_TOKEN_EXPIRED(message: message)
        case "1019":  self = .REFRESH_TOKEN_PEER_NOT_MATCHED(message: message)
        case "1020":  self = .REFRESH_TOKEN_USER_NOT_MATCHED(message: message)
        case "1021":  self = .REFRESH_TOKEN_EXPIRED(message: message)
        case "1022":  self = .REFRESH_TOKEN_NOT_VALID(message: message)
        case "1023":  self = .ACCESS_TOKEN_ISSUED_DATE_NOT_MATCHED(message: message)
        case "1024":  self = .BUSINESS_ERROR(message: message)
        case "1025":  self = .EXTERNAL_HTTP_CLIENT_ERROR(message: message)
        case "1026":  self = .INTERNAL_ERROR(message: message)
        default:    self = .CLIENT_ERROR(message: message)
        }
    }
}

private extension JuinjangError {
    var code: String {
        switch self {
        case .VALIDATION_ERROR:                     return "1000"
        case .WRONG_VALUE:                          return "1001"
        case .NOT_FOUND:                            return "1002"
        case .AUTH_REQUIRED:                        return "1003"
        case .ACCESS_DENIED:                        return "1004"
        case .DUPLICATE_KEY:                        return "1005"
        case .FK_CONFLICT_DELETE:                   return "1006"
        case .FK_REF_NOT_FOUND:                     return "1007"
        case .NOT_NULL_VIOLATION:                   return "1008"
        case .DATA_TOO_LONG:                        return "1009"
        case .CHECK_CONSTRAINT:                     return "1010"
        case .DATA_INTEGRITY_VIOLATION:             return "1011"
        case .ACCESS_TOKEN_NOT_VALID:               return "1017"
        case .ACCESS_TOKEN_EXPIRED:                 return "1018"
        case .REFRESH_TOKEN_PEER_NOT_MATCHED:       return "1019"
        case .REFRESH_TOKEN_USER_NOT_MATCHED:       return "1020"
        case .REFRESH_TOKEN_EXPIRED:                return "1021"
        case .REFRESH_TOKEN_NOT_VALID:              return "1022"
        case .ACCESS_TOKEN_ISSUED_DATE_NOT_MATCHED: return "1023"
        case .BUSINESS_ERROR:                       return "1024"
        case .EXTERNAL_HTTP_CLIENT_ERROR:           return "1025"
        case .INTERNAL_ERROR:                       return "1026"
        case .CLIENT_ERROR:                         return "9000"
        case .REISSUE_FAILED:                       return "9001"
        }
    }
}

private extension JuinjangError {
    var userFriendlyMessage: String {
        switch self {
        case .VALIDATION_ERROR:                     return "요청한 내용이 올바르지 않습니다.\n입력 정보를 다시 확인해 주세요."
        case .WRONG_VALUE:                          return "잘못된 값이 입력되었습니다.\n다시 시도해 주세요."
        case .NOT_FOUND:                            return "요청하신 정보를 찾을 수 없습니다."
        case .AUTH_REQUIRED:                        return "로그인이 필요합니다.\n로그인 후 다시 이용해 주세요."
        case .ACCESS_DENIED:                        return "접근 권한이 없습니다."
        case .DUPLICATE_KEY:                        return "이미 사용 중인 값입니다."
        case .FK_CONFLICT_DELETE:                   return "관련된 정보가 있어 삭제할 수 없습니다."
        case .FK_REF_NOT_FOUND:                     return "참조된 정보를 찾을 수 없습니다."
        case .NOT_NULL_VIOLATION:                   return "필수 입력값이 비어 있습니다.\n확인 후 다시 시도해 주세요."
        case .DATA_TOO_LONG:                        return "입력 가능한 글자 수를 초과했습니다."
        case .CHECK_CONSTRAINT:                     return "허용되지 않는 값이 입력되었습니다.\n다시 확인해 주세요."
        case .DATA_INTEGRITY_VIOLATION:             return "요청을 처리할 수 없습니다.\n입력한 내용을 다시 확인해 주세요."
        case .ACCESS_TOKEN_NOT_VALID:               return "로그인 정보가 유효하지 않습니다.\n다시 로그인해 주세요."
        case .ACCESS_TOKEN_EXPIRED:                 return "로그인 정보가 만료되었습니다.\n다시 로그인해 주세요."
        case .REFRESH_TOKEN_PEER_NOT_MATCHED:       return "토큰 정보가 일치하지 않습니다.\n다시 로그인해 주세요."
        case .REFRESH_TOKEN_USER_NOT_MATCHED:       return "로그인 정보가 유효하지 않습니다.\n다시 로그인해 주세요."
        case .REFRESH_TOKEN_EXPIRED:                return "로그인 정보가 만료되었습니다.\n다시 로그인해 주세요."
        case .REFRESH_TOKEN_NOT_VALID:              return "로그인 정보가 유효하지 않습니다.\n다시 로그인해 주세요."
        case .ACCESS_TOKEN_ISSUED_DATE_NOT_MATCHED: return "로그인 정보가 일치하지 않습니다.\n다시 로그인해 주세요."
        case .BUSINESS_ERROR:                       return "서비스 처리 중 문제가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .EXTERNAL_HTTP_CLIENT_ERROR:           return "외부 서비스 요청 중 문제가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .INTERNAL_ERROR:                       return "일시적인 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .CLIENT_ERROR:                         return "오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .REISSUE_FAILED:                       return "세션이 만료되었습니다.\n다시 로그인해 주세요."
        }
    }
}
