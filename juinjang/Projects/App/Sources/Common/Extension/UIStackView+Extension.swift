//
//  UIStackView+Extension.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit

extension UIStackView {
    func design(axis: NSLayoutConstraint.Axis = .horizontal, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .equalSpacing, spacing: CGFloat = 4) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
