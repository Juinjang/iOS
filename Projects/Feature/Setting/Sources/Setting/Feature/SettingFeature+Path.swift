import ComposableArchitecture

// MARK: - SettingFeature.Path
/// 설정 화면에서 push되는 네비게이션 스택의 destination 종류.

extension SettingFeature {
    @Reducer(state: .equatable, .sendable, action: .sendable)
    public enum Path {
        case termsList(TermsListFeature)
        case termsDetail(TermsDetailFeature)
        case marketingNotice(MarketingNoticeFeature)
        case qna(QnAFeature)
    }
}
