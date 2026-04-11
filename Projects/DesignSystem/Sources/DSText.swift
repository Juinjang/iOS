import SwiftUI

// MARK: - DSText
/// DSLabel의 SwiftUI 버전
/// Pretendard 폰트 + lineHeight + letterSpacing 자동 적용
///
/// 사용법:
/// ```
/// DSText("제목")
///     .style(.h1)
///     .dsColor(.main)
///
/// DSText("본문 텍스트")
///     .style(.body)
///     .dsColor(.gray600)
///     .dsAlignment(.center)
///     .dsMaxLines(2)
/// ```

public struct DSText: View {
    private let text: String
    private var fontStyle: DSFontStyle = .body
    private var color: Color = .gray600
    private var alignment: TextAlignment = .leading
    private var maxLines: Int?

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(fontStyle.font)
            .foregroundStyle(color)
            .lineSpacing(fontStyle.lineHeight - fontStyle.size)
            .kerning(fontStyle.letterSpacing)
            .multilineTextAlignment(alignment)
            .lineLimit(maxLines)
    }
}

// MARK: - Chaining Modifiers

public extension DSText {
    func style(_ style: DSFontStyle) -> DSText {
        var copy = self
        copy.fontStyle = style
        return copy
    }

    func dsColor(_ color: Color) -> DSText {
        var copy = self
        copy.color = color
        return copy
    }

    func dsAlignment(_ alignment: TextAlignment) -> DSText {
        var copy = self
        copy.alignment = alignment
        return copy
    }

    func dsMaxLines(_ lines: Int?) -> DSText {
        var copy = self
        copy.maxLines = lines
        return copy
    }
}
