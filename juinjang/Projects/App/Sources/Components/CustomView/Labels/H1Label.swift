//
//  BoldLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/31/25.
//

import UIKit

final class H1Label: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 24
        fontWeight = .bold
        lineHeight = 32.4
        letterSpacing = -0.48
    }
}
