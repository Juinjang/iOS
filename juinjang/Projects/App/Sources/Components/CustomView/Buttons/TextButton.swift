//
//  TextButton.swift
//  App
//
//  Created by KimDongWoo on 12/12/25.
//

import UIKit

final class TextButton: UIButton {
    
    init(text: String,
         color: UIColor = .main,
         font: UIFont = .pretendard(size: 14, weight: .medium),
         underline: Bool = false) {
        super.init(frame: .zero)
        commonInit(font)
        setText(text, color: color, underline: underline)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(_ font: UIFont) {
        titleLabel?.font = font
        backgroundColor = .clear
    }
    
    func setText(_ text: String,
                 color: UIColor = .main,
                 font: UIFont = .pretendard(size: 14, weight: .medium),
                 underline: Bool = false) {
        titleLabel?.font = font
        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        
        if underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            attributes[.underlineColor] = color
        }
        
        let attributedTitle = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
