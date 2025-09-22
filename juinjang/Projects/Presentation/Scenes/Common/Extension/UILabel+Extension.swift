//
//  UILabel+Extension.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import Foundation
import UIKit

extension UILabel {
    
    func design(text: String = "",
                textColor: UIColor = .gray500,
                font: UIFont = .systemFont(ofSize: 14),
                textAlignment: NSTextAlignment = .left,
                numberOfLines: Int = 1) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
    
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
    
    func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
        attributedText = attributedString
    }
    
    func changeFont(targetString: String, font: UIFont) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: font, range: (text as NSString).range(of: targetString))
        
        self.attributedText = attributedString
    }
    
    
    func setAttribute(
        text: String?,
        color: UIColor = .gray600,
        font: UIFont? = .pretendard(size: 14, weight: .regular),
        lineHeight: CGFloat = 30,
        charSpacing: CGFloat = -0.02,
        alignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail
    ) {
        guard let text, let font else { return }

        let resultText = text.isEmpty ? "" : text
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = alignment
        style.lineBreakMode = lineBreakMode
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 2,
            .kern: charSpacing,
            .font: font,
            .foregroundColor: color
        ]
        
        let attrString = NSAttributedString(string: resultText, attributes: attributes)
        self.attributedText = attrString
    }
    
    func truncatedText(for text: String?, maxWidth: CGFloat) -> String {
        guard let originalText = text else { return "" }
        
        let font = self.font ?? UIFont.systemFont(ofSize: 13)
        var currentWidth: CGFloat = 0
        var result = ""
        
        for char in originalText {
            let charAsString = String(char)
            let charWidth = charAsString.width(forFont: font)
            
            if currentWidth + charWidth > (maxWidth+10) {
                return result + "..."
            }
            
            result += charAsString
            currentWidth += charWidth
        }
        
        return originalText
    }
}
