//
//  MediumLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/31/25.
//

import UIKit

final class MediumLabel: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 16
        fontColor = .gray450
        fontWeight = .medium
    }
}
