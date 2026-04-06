import SwiftUI

public struct UpdateAlertView: View {
    private let onUpdate: () -> Void

    public init(onUpdate: @escaping () -> Void) {
        self.onUpdate = onUpdate
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Image("UpdateBackground", bundle: .module)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()

                    Image("UpdatePerson", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40.6, height: 58)
                        .padding(.bottom, 8)
                }

                Text("우리 업데이트 하러갈까요?")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.main)
                    .padding(.top, 21)

                Text("주인장 크루들이 오류와 사용성을 개선했어요.\n지금 바로 레벨업한 주인장을 확인해보세요!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.gray600)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.top, 16)

                Spacer()

                Button(action: onUpdate) {
                    Text("업데이트하러 가기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.gray500)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 13)
            }
            .frame(width: 342, height: 325)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
