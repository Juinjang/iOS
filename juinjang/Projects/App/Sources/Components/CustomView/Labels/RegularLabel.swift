//
//  RegularLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/31/25.
//

import UIKit

final class RegularLabel: BaseAttributedLabel {
    override func commonInit() {
        super.commonInit()
        fontSize = 13
        fontColor = .gray400
        fontWeight = .regular
    }
}
