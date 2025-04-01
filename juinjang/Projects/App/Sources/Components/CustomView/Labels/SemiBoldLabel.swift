//
//  SemiBoldLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/1/25.
//

import UIKit

final class SemiBoldLabel: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 14
        fontColor = .gray500
        fontWeight = .semiBold
    }
}
