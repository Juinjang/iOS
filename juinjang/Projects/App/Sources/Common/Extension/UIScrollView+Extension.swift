//
//  UIScrollView+Extension.swift
//  App
//
//  Created by KimDongWoo on 1/24/26.
//

import UIKit

extension UIScrollView {
    var scrollPercent: Int {
        let scrollable = max(1, contentSize.height - bounds.height)
        let raw = (contentOffset.y / scrollable) * 100
        return Int(raw).clamped(to: 0...100)
    }
}
