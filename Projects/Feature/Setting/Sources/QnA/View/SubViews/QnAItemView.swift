import DesignSystem
import Model
import SwiftUI

struct QnAItemView: View {
    let item: QnAItem
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 8) {
                    Image.qna
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.main200)

                    Text(highlightedQuestion)
                        .font(DSFontStyle.title.font)
                        .foregroundStyle(Color.gray500)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image.expandDown
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(isExpanded ? Color.gray420 : Color.gray200)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .contentShape(Rectangle())
                .padding(.horizontal, 22)
                .padding(.vertical, 24)
                .sectionDivider(.bottom)
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack {
                    DSText(item.answer)
                        .style(.body2)
                        .textColor(.gray500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray100)
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(
                            .easeOut(duration: 0.35).delay(0.1)
                        ),
                        removal: .opacity.animation(
                            .easeIn(duration: 0.1)
                        )
                    )
                )
            }
        }
    }

    private var highlightedQuestion: AttributedString {
        var attributed = AttributedString(item.question)
        if let range = attributed.range(of: item.highlight) {
            attributed[range].foregroundColor = .main
        }
        return attributed
    }
}
