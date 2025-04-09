//
//  AttributeLabelable.swift
//  juinjang
//
//  Created by KimDongWoo on 4/1/25.
//

import UIKit

protocol AttributeLabelable: UILabel {
    var fontColor: UIColor { get set }
    var fontSize: CGFloat { get set }
    var letterSpacing: CGFloat { get set }
    var fontAlignment: NSTextAlignment { get set }
    var fontWeight: UIFont.PretendardWeight { get set }
    var maxTextWidth: CGFloat? { get set }
    var lineHeight: CGFloat { get set }
    
    func updateAttributedText()
}

extension AttributeLabelable {
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
