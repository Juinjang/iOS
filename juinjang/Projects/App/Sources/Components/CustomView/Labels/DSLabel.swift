//
//  DSLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/1/25.
//

import UIKit

enum DSFontStyle {
    case h1, h2, h3, h4
    case title, body, body2
    case reguler
    
    var size: CGFloat {
        switch self {
        case .h1: return 24
        case .h2, .h4: return 20
        case .h3: return 18
        case .title, .body: return 16
        case .body2: return 14
        case .reguler: return 13
        }
    }
    
    var weight: UIFont.PretendardWeight {
        switch self {
        case .h1, .h2, .h3: return .bold
        case .h4, .title: return .semiBold
        case .body, .body2: return .medium
        case .reguler: return .regular
        }
    }
}

final class DSLabel: UILabel {
    var fontColor: UIColor = .gray400 { didSet { updateAttributedText() } }
    var fontAlignment: NSTextAlignment = .left { didSet { updateAttributedText() } }
    var fontSize: CGFloat = 14 { didSet { updateAttributedText() } }
    var fontWeight: UIFont.PretendardWeight = .bold { didSet { updateAttributedText() }}
    var maxTextWidth: CGFloat? { didSet { updateAttributedText() } }
    
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
    
    func commonInit() {
        numberOfLines = 0
        lineBreakMode = .byTruncatingTail
    }
    
    func setLineHeight(_ height: CGFloat) {
        self._lineHeight = height
        updateAttributedText()
    }
    
    func updateAttributedText() {
        setAttribute(
            text: maxTextWidth.flatMap {
                truncatedText(for: text, maxWidth: $0)
            } ?? (text ?? ""),
            color: fontColor,
            font: UIFont.pretendard(size: fontSize, weight: fontWeight),
            lineHeight: lineHeight,
            charSpacing: letterSpacing,
            alignment: fontAlignment
        )
    }
}

