// MARK: - 요청 타입 정의

public enum RequestTask {
    case requestPlain                    // 파라미터 없음
    case requestQuery(Encodable)         // URL 쿼리 파라미터
    case requestBody(Encodable)          // JSON Body
}
