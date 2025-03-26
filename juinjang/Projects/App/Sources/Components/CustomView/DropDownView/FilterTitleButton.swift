//
//  FilterTitleButton.swift
//  juinjang
//
//  Created by 조유진 on 3/13/25.
//

import UIKit
import SnapKit

final class FilterTitleButton: UIButton {
    private var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    init(title: String) {
        super.init(frame: .zero)
        configureView(title: title)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(title: String) {
        setTitle(title, for: .normal)
        setImage(.ImjangList.arrowDown, for: .normal)
        titleLabel?.setAttribute(text: title, color: .gray450, font: .pretendard(size: 14, weight: .semiBold), lineHeight: 19)
        setTitleColor(.gray450, for: .normal)
        backgroundColor = .white
    
        layer.cornerRadius = 10
        let intervalSpacing = 2.0
        let halfIntervalSpacing = intervalSpacing / 2
    
        semanticContentAttribute = .forceRightToLeft
        contentEdgeInsets = .init(top: 0, left: halfIntervalSpacing + padding.left, bottom: 0, right: halfIntervalSpacing - padding.right)
        imageEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: -halfIntervalSpacing)
        titleEdgeInsets = .init(top: 0, left: -halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        contentHorizontalAlignment = .left
    }
    
    func updateTitle(title: String) {
        setTitle(title, for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
