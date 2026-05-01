import Foundation

// MARK: - SettingAlert
/// 설정 화면에서 띄우는 DSAlert의 종류 (state 측 모델).
/// `Action.Alert`(reducer가 받는 응답 액션)와는 다른 개념 — 표시할 내용과 식별만 담당.

extension SettingFeature {
    public enum SettingAlert: Equatable, Identifiable, Sendable {
        case logoutConfirm(nickname: String, email: String)
        case accountDeleteConfirm

        case profileLoadFailed
        case nicknameUpdateFailed
        case introUpdateFailed
        case logoutFailed
        case profileImageUploadFailed

        public var id: String {
            switch self {
            case .logoutConfirm: return "logoutConfirm"
            case .accountDeleteConfirm: return "accountDeleteConfirm"
            case .profileLoadFailed: return "profileLoadFailed"
            case .nicknameUpdateFailed: return "nicknameUpdateFailed"
            case .introUpdateFailed: return "introUpdateFailed"
            case .logoutFailed: return "logoutFailed"
            case .profileImageUploadFailed: return "profileImageUploadFailed"
            }
        }
    }
}
