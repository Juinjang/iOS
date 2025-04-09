//
//  MediumLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/31/25.
//

import UIKit

final class H2Label: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 20
        fontWeight = .bold
        lineHeight = 27
        letterSpacing = -0.4
    }
}
