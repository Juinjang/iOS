// MARK: - 인증 타입 정의

public enum AuthorizationType: Sendable {
    case none
    case bearer   // Authorization: Bearer <토큰> 추가
}
