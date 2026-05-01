import Foundation

// MARK: - PolicyTable
/// 약관/정책 본문 안에 들어가는 데이터 표 (개인정보 처리방침의 위탁 현황표 등)
public struct PolicyTable: Equatable, Sendable, Hashable {
    public let headers: [String]
    public let rows: [[String]]

    public init(headers: [String], rows: [[String]]) {
        self.headers = headers
        self.rows = rows
    }
}

// MARK: - TermsContentSegment
/// 본문은 단순 텍스트가 아니라 "텍스트와 표가 번갈아 나오는 시퀀스"로 모델링.
/// 렌더러는 segment 순서대로 그려서 develop 브랜치 시절의 본문↔이미지표 인터리브 레이아웃을 재현.
public enum TermsContentSegment: Equatable, Sendable, Hashable {
    /// markdown 텍스트 (`**bold**` 사용 가능)
    case text(String)
    /// 본문 사이에 박히는 데이터 표
    case table(PolicyTable)
}
