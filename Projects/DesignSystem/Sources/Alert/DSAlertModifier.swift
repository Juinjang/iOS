import SwiftUI

// MARK: - dsAlert(item:content:) modifier
/// `Item?` 바인딩으로 알림 표시를 토글합니다.
/// 백드롭 + 페이드 트랜지션은 모디파이어가 책임지고,
/// 컨테이너 chrome은 `DSAlert`가 책임집니다.
///
/// TCA 연동:
/// ```
/// .dsAlert(item: $store.scope(state: \.alert, action: \.alert)) { state in
///     DSAlert(...)
/// }
/// ```
///
/// 일반 SwiftUI 사용:
/// ```
/// @State private var alert: AlertModel?
/// ...
/// .dsAlert(item: $alert) { model in
///     DSAlert(...)
/// }
/// ```

public extension View {
    func dsAlert<Item, AlertContent: View>(
        item: Binding<Item?>,
        dismissOnBackdropTap: Bool = true,
        @ViewBuilder content: @escaping (Item) -> AlertContent
    ) -> some View {
        modifier(
            DSAlertModifier(
                item: item,
                dismissOnBackdropTap: dismissOnBackdropTap,
                alertContent: content
            )
        )
    }
}

// MARK: - Internal modifier

private struct DSAlertModifier<Item, AlertContent: View>: ViewModifier {
    @Binding var item: Item?
    let dismissOnBackdropTap: Bool
    let alertContent: (Item) -> AlertContent

    func body(content: Content) -> some View {
        ZStack {
            content

            if let unwrapped = item {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if dismissOnBackdropTap {
                                item = nil
                            }
                        }

                    alertContent(unwrapped)
                        .padding(.horizontal, 24)
                        .accessibilityAddTraits(.isModal)
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: item == nil)
    }
}
