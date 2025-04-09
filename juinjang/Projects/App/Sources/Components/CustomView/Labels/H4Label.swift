//
//  SemiBoldLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/1/25.
//

import UIKit

final class H4Label: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 20
        fontWeight = .semiBold
        lineHeight = 27
        letterSpacing = -0.4
    }
}
