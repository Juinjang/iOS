//
//  FilterButton.swift
//  juinjang
//
//  Created by 조유진 on 3/13/25.
//

import UIKit
import RxSwift
import RxRelay

final class FilterButton: UIButton {
    private var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private var disposeBag = DisposeBag()
    
    init(filterType: LookAroundFilterType) {
        super.init(frame: .zero)
        configureView(filterType: filterType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(filterType: LookAroundFilterType) {
        let title = filterType.rawValue
        setTitle(title, for: .normal)
        titleLabel?.setAttribute(text: title, color: .gray300, font: .pretendard(size: 14, weight: .medium), lineHeight: 19)
        setTitleColor(.gray300, for: .normal)
        backgroundColor = .white
        contentEdgeInsets = UIEdgeInsets(top: 0, left: padding.left, bottom: 0, right: padding.right)
        contentHorizontalAlignment = .leading
        titleLabel?.alpha = 0
        layoutIfNeeded()
    }
    
    func updateColor(isSelected: Bool) {
        if isSelected {
            setTitleColor(.gray450, for: .normal)
            titleLabel?.setAttribute(text: titleLabel?.text, color: .gray450, font: .pretendard(size: 14, weight: .semiBold), lineHeight: 19)
        } else {
            setTitleColor(.gray300, for: .normal)
            titleLabel?.setAttribute(text: titleLabel?.text, color: .gray300, font: .pretendard(size: 14, weight: .medium), lineHeight: 19)
        }
    }
    
     override var intrinsicContentSize: CGSize {
         var contentSize = super.intrinsicContentSize
         contentSize.height += padding.top + padding.bottom
         contentSize.width += padding.left + padding.right

         return contentSize
     }
}
