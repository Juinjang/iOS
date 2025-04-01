//
//  PaddingButton.swift
//  juinjang
//
//  Created by 강동영 on 3/13/25.
//

import UIKit

class PaddingButton: UIButton {
    private var padding = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 15.0, right: 0.0)
    
    init(padding: UIEdgeInsets) {
        super.init(frame: .zero)
        self.padding = padding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}
