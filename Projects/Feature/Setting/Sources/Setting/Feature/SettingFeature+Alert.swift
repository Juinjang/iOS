import Foundation

// MARK: - SettingAlert
/// 설정 화면에서 띄우는 DSAlert의 종류 (state 측 모델).
/// `Action.Alert`(reducer가 받는 응답 액션)와는 다른 개념 — 표시할 내용과 식별만 담당.

extension SettingFeature {
    public enum SettingAlert: Equatable, Identifiable, Sendable {
        case logoutConfirm(nickname: String, email: String)

        case profileLoadFailed
        case nicknameUpdateFailed
        case introUpdateFailed
        case logoutFailed
        case profileImageUploadFailed

        public var id: String {
            switch self {
            case .logoutConfirm: return "logoutConfirm"
            case .profileLoadFailed: return "profileLoadFailed"
            case .nicknameUpdateFailed: return "nicknameUpdateFailed"
            case .introUpdateFailed: return "introUpdateFailed"
            case .logoutFailed: return "logoutFailed"
            case .profileImageUploadFailed: return "profileImageUploadFailed"
            }
        }

        public var title: String {
            switch self {
            case let .logoutConfirm(nickname, _): return nickname
            case .profileLoadFailed,
                 .nicknameUpdateFailed,
                 .introUpdateFailed,
                 .logoutFailed,
                 .profileImageUploadFailed:
                return "주인장"
            }
        }

        public var subtitle: String? {
            switch self {
            case let .logoutConfirm(_, email): return email
            default: return nil
            }
        }

        public var message: String {
            switch self {
            case .logoutConfirm: return "계정에서 로그아웃할까요?"
            case .profileLoadFailed: return "프로필 정보를 불러오지 못했어요"
            case .nicknameUpdateFailed: return "닉네임 변경에 실패했어요"
            case .introUpdateFailed: return "한줄소개 변경에 실패했어요"
            case .logoutFailed: return "로그아웃에 실패했어요\n다시 시도해주세요"
            case .profileImageUploadFailed: return "프로필 사진 업로드에 실패했어요"
            }
        }
    }
}
