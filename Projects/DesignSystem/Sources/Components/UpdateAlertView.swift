import SwiftUI

// MARK: - UpdateAlertView
/// 앱 업데이트 안내 팝업

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
                // MARK: - 배경 이미지 + 사람 이미지
                ZStack(alignment: .bottom) {
                    Image.updateBackground
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()

                    Image.updatePerson
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40.6, height: 58)
                        .padding(.bottom, 8)
                }

                // MARK: - 텍스트
                DSText("우리 업데이트 하러갈까요?")
                    .style(.h4)
                    .textColor(.main)
                    .padding(.top, 21)

                DSText("주인장 크루들이 오류와 사용성을 개선했어요.\n지금 바로 레벨업한 주인장을 확인해보세요!")
                    .style(.body)
                    .textColor(.gray600)
                    .textAlignment(.center)
                    .padding(.top, 16)

                Spacer()

                // MARK: - 업데이트 버튼
                AppButton("업데이트하러 가기", style: .gray) {
                    onUpdate()
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
