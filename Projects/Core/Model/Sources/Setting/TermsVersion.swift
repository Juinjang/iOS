import Foundation

// MARK: - TermsVersion
/// 한 약관 문서의 한 버전. (id, 시행일, 본문 segments)
/// 가장 최신 버전이 배열의 첫 원소가 되도록 콘텐츠 파일에서 정렬.
public struct TermsVersion: Equatable, Sendable, Hashable, Identifiable {
    public let id: String              // "1.1.0", "1.0.0"
    public let effectiveDate: String   // "2025.01.12"
    public let segments: [TermsContentSegment]

    public init(
        id: String,
        effectiveDate: String,
        segments: [TermsContentSegment]
    ) {
        self.id = id
        self.effectiveDate = effectiveDate
        self.segments = segments
    }

    /// 드롭다운 표기: "이용약관 버전 1.1.0 (시행일 2025.01.12)"
    public var displayLabel: String {
        "이용약관 버전 \(id) (시행일 \(effectiveDate))"
    }
}
