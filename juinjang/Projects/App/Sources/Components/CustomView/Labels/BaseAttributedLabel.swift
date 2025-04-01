//
//  BaseAttributedLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/1/25.
//

import UIKit

class BaseAttributedLabel: UILabel, AttributeLabelable {
    var fontColor: UIColor = .gray400 { didSet { updateAttributedText() } }
    var fontSize: CGFloat = 14 { didSet { updateAttributedText() } }
    var charSpacing: CGFloat = -0.02 { didSet { updateAttributedText() } }
    var fontAlignment: NSTextAlignment = .left { didSet { updateAttributedText() } }
    var fontWeight: UIFont.PretendardWeight = .bold { didSet { updateAttributedText() }}
    var maxTextWidth: CGFloat? { didSet { updateAttributedText() } }

    override var text: String? {
        didSet { updateAttributedText() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        numberOfLines = 0
        lineBreakMode = .byTruncatingTail
    }
}
