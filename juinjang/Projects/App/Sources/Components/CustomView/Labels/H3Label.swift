//
//  RegularLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/31/25.
//

import UIKit

final class H3Label: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 18
        fontWeight = .bold
        lineHeight = 24.3
        letterSpacing = -0.36
    }
}
