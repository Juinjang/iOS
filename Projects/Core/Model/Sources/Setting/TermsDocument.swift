import Foundation

// MARK: - TermsDocument
/// Setting 화면 / Onboarding 동의 단계 등에서 표시하는 약관/정책 종류.
/// 본문 텍스트는 도메인 데이터로 취급해 Content/ 폴더의 별도 파일에 보관.

public enum TermsDocument: String, Equatable, Sendable, CaseIterable {
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

    public var body: String {
        switch self {
        case .termsOfService:    return TermsOfServiceContent.body
        case .privacyPolicy:     return PrivacyPolicyContent.body
        case .marketingConsent:  return MarketingConsentContent.body
        }
    }
}
