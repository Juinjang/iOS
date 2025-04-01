//
//  SemiBoldLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/1/25.
//

import UIKit

final class SemiBoldLabel: UILabel {
    override var text: String? {
        didSet {
            updateAttributedText()
        }
    }
    
    var fontColor: UIColor = .gray500 {
        didSet {
            updateAttributedText()
        }
    }
    
    var fontSize: CGFloat = 14 {
        didSet {
            updateAttributedText()
        }
    }

    var charSpacing: CGFloat = -0.02 {
        didSet {
            updateAttributedText()
        }
    }

    var fontAlignment: NSTextAlignment = .left {
        didSet {
            updateAttributedText()
        }
    }
    
    // MARK: - maxTextWidth 글자가 넘어가면 "..." 처리
    var maxTextWidth: CGFloat? {
        didSet {
            updateAttributedText()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup
    private func commonInit() {
        numberOfLines = 0
        lineBreakMode = .byTruncatingTail
    }
    
    private func updateAttributedText() {
        setAttribute(
            text: maxTextWidth.flatMap {
                truncatedText(for: text, maxWidth: $0)
            } ?? (text ?? ""),
            color: fontColor,
            font: UIFont.pretendard(size: fontSize, weight: .semiBold),
            lineHeight: fontSize*1.45,
            charSpacing: charSpacing,
            alignment: fontAlignment
        )
    }
}

