//
//  TitleLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

final class TitleLabel: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 16
        fontWeight = .semiBold
        lineHeight = 23.2
        letterSpacing = -0.32
    }
}
