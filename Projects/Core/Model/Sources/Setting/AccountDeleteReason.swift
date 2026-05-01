import Foundation

public enum AccountDeleteReason: String, CaseIterable, Equatable, Sendable, Identifiable {
    case notUse = "NOT_USE"
    case cannotUse = "CANNOT_USE"
    case notHelp = "NOT_HELP"
    case cannotFunction = "CANNOT_FUNCTION"
    case concernSecurity = "CONCERN_SECURITY"
    case otherService = "OTHER_SERVICE"

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .notUse: return "더 이상 쓸 일이 없어요"
        case .cannotUse: return "앱 사용법을 모르겠어요"
        case .notHelp: return "임장에 도움이 되지 않아요"
        case .cannotFunction: return "앱이 정상적으로 작동하지 않아요"
        case .concernSecurity: return "보안이 걱정돼요"
        case .otherService: return "다른 서비스가 더 좋아요"
        }
    }
}
