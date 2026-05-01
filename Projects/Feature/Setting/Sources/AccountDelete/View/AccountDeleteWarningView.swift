import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct AccountDeleteWarningView: View {
    @Bindable var store: StoreOf<AccountDeleteFlowFeature>

    public init(store: StoreOf<AccountDeleteFlowFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationDestination(
                    isPresented: Binding(
                        get: { store.isShowingReason },
                        set: { store.send(.view(.isShowingReasonChanged($0))) }
                    )
                ) {
                    AccountDeleteReasonView(store: store)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image.deleteLogo
                .resizable()
                .scaledToFit()
                .frame(width: 49, height: 51)
                .padding(.top, 33)
                .padding(.leading, 24)

            (Text("\(store.nickname)님,\n").foregroundStyle(Color.gray600)
             + Text("정말 계정을 삭제하시겠어요?").foregroundStyle(Color.gray600))
                .font(DSFontStyle.h2.font)
                .lineSpacing(3)
                .padding(.top, 31)
                .padding(.horizontal, 24)

            DSText("계정을 없애면 임장노트의 내용은 복구할 수 없게 돼요.\n지금 취소하면 아래의 혜택을 계속 누릴 수 있어요.")
                .style(.body)
                .textColor(.gray500)
                .padding(.top, 32)
                .padding(.horizontal, 24)

            BenefitListView()
                .padding(.top, 36)
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
                    store.send(.view(.isShowingReasonChanged(true)))
                } label: {
                    DSText("네, 계정을 삭제할게요")
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
    }
}

#Preview("AccountDeleteWarning") {
    AccountDeleteWarningView(
        store: Store(initialState: AccountDeleteFlowFeature.State(nickname: "땡땡")) {
            AccountDeleteFlowFeature()
        }
    )
}
