//
//  DSLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/1/25.
//

import UIKit

public enum DSFontStyle {
    case h1, h2, h3, h4
    case title, body, body2
    case reguler
    
    public var size: CGFloat {
        switch self {
        case .h1: return 24
        case .h2, .h4: return 20
        case .h3: return 18
        case .title, .body: return 16
        case .body2: return 14
        case .reguler: return 13
        }
    }
    
    public var weight: UIFont.PretendardWeight {
        switch self {
        case .h1, .h2, .h3: return .bold
        case .h4, .title: return .semiBold
        case .body, .body2: return .medium
        case .reguler: return .regular
        }
    }
}

public final class DSLabel: UILabel {
    public var fontColor: UIColor = .gray600 { didSet { updateAttributedText() } }
    public var fontAlignment: NSTextAlignment = .left { didSet { updateAttributedText() } }
    public var fontSize: CGFloat = 14 { didSet { updateAttributedText() } }
    public var fontWeight: UIFont.PretendardWeight = .bold { didSet { updateAttributedText() }}
    public var maxTextWidth: CGFloat? { didSet { updateAttributedText() } }
    
    private var _lineHeight: CGFloat?
    
    private var lineHeight: CGFloat {
        return _lineHeight ?? (fontSize >= 18 ? fontSize * 1.35 : fontSize * 1.45)
    }
    
    private var letterSpacing: CGFloat {
        return fontSize * -0.02
    }

    override var text: String? {
        didSet { updateAttributedText() }
    }
    
    override var lineBreakMode: NSLineBreakMode {
         didSet { updateAttributedText() }
     }
    
    public var textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    init(_ style: DSFontStyle) {
        self.fontSize = style.size
        self.fontWeight = style.weight
        super.init(frame: .zero)
        commonInit()
        updateAttributedText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
    
    public func commonInit() {
        numberOfLines = 0
        lineBreakMode = .byTruncatingTail
    }
    
    public func setLineHeight(_ height: CGFloat) {
        self._lineHeight = height
        updateAttributedText()
    }
    
    public func updateAttributedText() {
        setAttribute(
            text: maxTextWidth.flatMap {
                truncatedText(for: text, maxWidth: $0)
            } ?? (text ?? ""),
            color: fontColor,
            font: UIFont.pretendard(size: fontSize, weight: fontWeight),
            lineHeight: lineHeight,
            charSpacing: letterSpacing,
            alignment: fontAlignment,
            lineBreakMode: lineBreakMode
        )
    }
    
    public func setHighlightedText(fullText: String,
                            highlightText: String,
                            highlightColor: UIColor) {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // 1. 먼저 기본 전체 스타일 적용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = self.lineHeight - self.fontSize
        paragraphStyle.alignment = self.fontAlignment
        
        attributedString.addAttributes([
            .font: UIFont.pretendard(size: fontSize, weight: fontWeight),
            .foregroundColor: fontColor,
            .kern: letterSpacing,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))
        
        // 2. 이후 하이라이트 부분 덮어쓰기
        if let range = fullText.range(of: highlightText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: highlightColor, range: nsRange)
        }
        
        self.attributedText = attributedString
    }
}

