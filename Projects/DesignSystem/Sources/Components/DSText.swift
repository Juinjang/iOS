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

public struct DSText: View {
    
    public struct HighlightStyle {
        var color: Color?
        var fontStyle: DSFontStyle?
        
        public init(color: Color? = nil, fontStyle: DSFontStyle? = nil) {
            self.color = color
            self.fontStyle = fontStyle
        }
    }
    
    private let text: String
    private var fontStyle: DSFontStyle = .body
    private var color: Color = .gray600
    private var alignment: TextAlignment = .leading
    private var lineLimit: Int?
    private var highlights: [(words: [String], style: HighlightStyle)] = []

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        buildText()
            .font(fontStyle.font)
            .foregroundStyle(color)
            .lineSpacing(fontStyle.lineHeight - fontStyle.size)
            .kerning(fontStyle.letterSpacing)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private func buildText() -> some View {
        if highlights.isEmpty {
            Text(text)
        } else {
            Text(makeAttributedString())
        }
    }
    
    private func makeAttributedString() -> AttributedString {
        var attributed = AttributedString(text)
        
        for highlight in highlights {
            for word in highlight.words {
                var searchRange = attributed.startIndex ..< attributed.endIndex
                
                while let range = attributed[searchRange].range(of: word) {
                    // 색상 적용
                    if let color = highlight.style.color {
                        attributed[range].foregroundColor = UIColor(color)
                    }
                    // 폰트 스타일 적용
                    if let fontStyle = highlight.style.fontStyle {
                        attributed[range].font = fontStyle.font
                    }
                    searchRange = range.upperBound ..< attributed.endIndex
                }
            }
        }
        
        return attributed
    }
}

// MARK: - Chaining Modifiers

public extension DSText {
    func style(_ style: DSFontStyle) -> DSText {
        var copy = self
        copy.fontStyle = style
        return copy
    }

    func textColor(_ color: Color) -> DSText {
        var copy = self
        copy.color = color
        return copy
    }

    func textAlignment(_ alignment: TextAlignment) -> DSText {
        var copy = self
        copy.alignment = alignment
        return copy
    }

    func maxLines(_ lines: Int?) -> DSText {
        var copy = self
        copy.lineLimit = lines
        return copy
    }
    
    func highlightWords(_ words: [String], style: HighlightStyle) -> DSText {
        var copy = self
        copy.highlights.append((words: words, style: style))
        return copy
    }
    
    func highlightWord(_ word: String, style: HighlightStyle) -> DSText {
        highlightWords([word], style: style)
    }
}
