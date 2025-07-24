//
//  TermTextStyle.swift
//  juinjang
//
//  Created by KimDongWoo on 7/24/25.
//

import UIKit

enum TermTextStyle: String, Codable {
    case title
    case subtitle
    case body
    case numbered
    case bullet
    case alphabet
    
    var attributes: [NSAttributedString.Key: Any] {
        let fontSize: CGFloat
        let fontWeight: UIFont.PretendardWeight
        
        switch self {
        case .title:
            fontSize = 16
            fontWeight = .semiBold
        case .subtitle:
            fontSize = 14
            fontWeight = .semiBold
        default:
            fontSize = 14
            fontWeight = .regular
        }
        
        let paragraphStyle = makeParagraphStyle(for: self, fontSize: fontSize)
        
        return [
            .font: UIFont.pretendard(size: fontSize, weight: fontWeight),
            .foregroundColor: UIColor.gray500,
            .paragraphStyle: paragraphStyle
        ]
    }
    
    private func makeParagraphStyle(for style: TermTextStyle, fontSize: CGFloat) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let lineHeight = fontSize * 1.35
        paragraphStyle.lineHeightMultiple = 1.35
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        
        switch style {
        case .numbered:
            paragraphStyle.firstLineHeadIndent = 5
            paragraphStyle.headIndent = 20
            paragraphStyle.defaultTabInterval = 1
            paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 0)]
        case .bullet:
            paragraphStyle.firstLineHeadIndent = 5.5
            paragraphStyle.headIndent = 20.5
            paragraphStyle.defaultTabInterval = 5
            paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 0)]
        case .alphabet:
            paragraphStyle.firstLineHeadIndent = 25
            paragraphStyle.headIndent = 40
            paragraphStyle.defaultTabInterval = 1
            paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 0)]
        default:
            break
        }
        
        return paragraphStyle
    }
}
