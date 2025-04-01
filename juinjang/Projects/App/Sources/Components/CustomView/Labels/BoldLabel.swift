//
//  BoldLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/31/25.
//

import UIKit

final class BoldLabel: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 16
        fontColor = .gray600
        fontWeight = .bold
    }
}
