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
        case .logoutConfirm:
            DSAlert(
                title: alert.title,
                titleColor: .main,
                subtitle: alert.subtitle,
                message: alert.message,
                actions: [
                    .secondary("아니요") { store.send(.alert(.dismiss)) },
                    .primary("로그아웃") { store.send(.alert(.presented(.logoutConfirmed))) }
                ]
            )

        case .profileLoadFailed,
             .nicknameUpdateFailed,
             .introUpdateFailed,
             .logoutFailed,
             .profileImageUploadFailed:
            DSAlert(
                title: alert.title,
                message: alert.message,
                actions: [.primary("확인") { store.send(.alert(.dismiss)) }]
            )
        }
    }
}
