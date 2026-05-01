import Foundation

// MARK: - TermsDocument
/// Setting 화면 / Onboarding 동의 단계 등에서 표시하는 약관/정책 종류.
/// 본문은 도메인 데이터로 취급해 Content/ 폴더 별도 파일에 보관하고,
/// 여기서는 versions 목록만 노출.

public enum TermsDocument: String, Equatable, Sendable, Hashable, CaseIterable {
    case termsOfService
    case privacyPolicy
    case marketingConsent

    public var title: String {
        switch self {
        case .termsOfService:    return "주인장 이용약관"
        case .privacyPolicy:     return "주인장 개인정보 처리방침"
        case .marketingConsent:  return "마케팅 동의 및 이벤트 수신"
        }
    }

    /// 가장 최신 버전이 배열의 첫 원소.
    public var versions: [TermsVersion] {
        switch self {
        case .termsOfService:    return TermsOfServiceContent.versions
        case .privacyPolicy:     return PrivacyPolicyContent.versions
        case .marketingConsent:  return MarketingConsentContent.versions
        }
    }

    public var latestVersion: TermsVersion {
        // versions는 항상 최소 1개 보장 (콘텐츠 파일 invariant)
        versions[0]
    }
}
