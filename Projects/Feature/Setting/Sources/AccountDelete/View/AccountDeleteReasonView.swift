import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

public struct AccountDeleteReasonView: View {
    let store: StoreOf<AccountDeleteFlowFeature>

    public init(store: StoreOf<AccountDeleteFlowFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image.deleteLogo
                .resizable()
                .scaledToFit()
                .frame(width: 49, height: 51)
                .padding(.top, 33)
                .padding(.leading, 24)

            (Text("더 나은 주인장").foregroundStyle(Color.main)
             + Text("이 되도록\n노력할게요").foregroundStyle(Color.gray600))
                .font(DSFontStyle.h2.font)
                .lineSpacing(3)
                .padding(.top, 31)
                .padding(.horizontal, 24)

            DSText("불편했던 점을 남겨주시면 주인장 팀에 큰 도움이 됩니다.\n다음에 또 만나요!")
                .style(.body)
                .textColor(.gray500)
                .padding(.top, 32)
                .padding(.horizontal, 24)

            VStack(spacing: 8) {
                ForEach(AccountDeleteReason.allCases) { reason in
                    ReasonOptionRow(
                        reason: reason,
                        isSelected: store.selectedReasons.contains(reason)
                    ) {
                        store.send(.view(.reasonToggled(reason)))
                    }
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 8) {
                Button {
                    store.send(.view(.cancelTapped))
                } label: {
                    DSText("취소하고 돌아갈래요")
                        .style(.title)
                        .textColor(.mainWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.gray600)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)

                Button {
                    store.send(.view(.finalDeleteTapped))
                } label: {
                    DSText("계정 삭제하기")
                        .style(.title)
                        .textColor(.mainWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.main)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 33)
        }
        .background(Color.mainWhite)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("AccountDeleteReason - empty") {
    AccountDeleteReasonView(
        store: Store(initialState: AccountDeleteFlowFeature.State(nickname: "땡땡")) {
            AccountDeleteFlowFeature()
        }
    )
}

#Preview("AccountDeleteReason - selected") {
    AccountDeleteReasonView(
        store: Store(
            initialState: AccountDeleteFlowFeature.State(
                nickname: "땡땡",
                selectedReasons: [.cannotUse, .notHelp, .concernSecurity]
            )
        ) {
            AccountDeleteFlowFeature()
        }
    )
}
