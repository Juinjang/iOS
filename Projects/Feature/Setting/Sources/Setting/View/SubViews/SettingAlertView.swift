import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - SettingAlertView
/// `SettingFeature.SettingAlert` 케이스별로 알맞은 `DSAlert`를 만들어주는 헬퍼 뷰.
/// SettingView에서 `.dsAlert(item:)`의 content 클로저로 사용.

struct SettingAlertView: View {
    let alert: SettingFeature.SettingAlert
    let store: StoreOf<SettingFeature>

    var body: some View {
        switch alert {
        case let .logoutConfirm(nickname, email):
            DSAlert(
                title: nickname,
                titleColor: .main,
                subtitle: email,
                message: "계정에서 로그아웃할까요?",
                actions: [
                    .secondary("아니요") { store.send(.alert(.dismiss)) },
                    .primary("로그아웃") { store.send(.alert(.presented(.logoutConfirmed))) }
                ]
            )

        case .profileLoadFailed:
            failureAlert(message: "프로필 정보를 불러오지 못했어요")

        case .nicknameUpdateFailed:
            failureAlert(message: "닉네임 변경에 실패했어요")

        case .introUpdateFailed:
            failureAlert(message: "한줄소개 변경에 실패했어요")

        case .logoutFailed:
            failureAlert(message: "로그아웃에 실패했어요\n다시 시도해주세요")

        case .profileImageUploadFailed:
            failureAlert(message: "프로필 사진 업로드에 실패했어요")
        }
    }

    /// 단일 "확인" 버튼 알림 — 모든 정보성 실패 알림이 공유.
    private func failureAlert(message: String) -> DSAlert<EmptyView> {
        DSAlert(
            title: "주인장",
            message: message,
            actions: [.primary("확인") { store.send(.alert(.dismiss)) }]
        )
    }
}
