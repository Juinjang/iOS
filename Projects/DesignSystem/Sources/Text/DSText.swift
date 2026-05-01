import SwiftUI

// MARK: - DSText
/// DSLabel의 SwiftUI 버전
/// Pretendard 폰트 + lineHeight + letterSpacing 자동 적용
///
/// 사용법:
/// ```
/// DSText("제목")
///     .style(.h1)
///     .textColor(.main)
///
/// DSText("본문 텍스트")
///     .style(.body)
///     .textColor(.gray600)
///     .textAlignment(.center)
///     .maxLines(2)
/// ```

public struct DSText: View, Sendable {
    nonisolated private let text: String
    nonisolated private var fontStyle: DSFontStyle = .body
    nonisolated private var color: Color = .gray600
    nonisolated private var alignment: TextAlignment = .leading
    nonisolated private var lineLimit: Int?

    public nonisolated init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(fontStyle.font)
            .foregroundStyle(color)
            .lineSpacing(fontStyle.lineHeight - fontStyle.size)
            .kerning(fontStyle.letterSpacing)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
}

// MARK: - Chaining Modifiers

public extension DSText {
    nonisolated func style(_ style: DSFontStyle) -> DSText {
        var copy = self
        copy.fontStyle = style
        return copy
    }

    nonisolated func textColor(_ color: Color) -> DSText {
        var copy = self
        copy.color = color
        return copy
    }

    nonisolated func textAlignment(_ alignment: TextAlignment) -> DSText {
        var copy = self
        copy.alignment = alignment
        return copy
    }

    nonisolated func maxLines(_ lines: Int?) -> DSText {
        var copy = self
        copy.lineLimit = lines
        return copy
    }
}
