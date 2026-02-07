//
//  UIScrollView+Extension.swift
//  App
//
//  Created by KimDongWoo on 1/24/26.
//

import UIKit

extension UIScrollView {
    var scrollPercent: Int {
        let raw = rawScrollMetric()
        return remapToPercent(value: raw)
    }
    
    /// 임시용 추후 삭제 예정
    private func rawScrollMetric() -> Int {
        let total = max(1, contentSize.height)
        let bottomY = min(total, contentOffset.y + bounds.height)
        return Int(((bottomY / total) * 100).rounded()).clamped(to: 0...100)
    }
    
    /// 원시값(예: 16~24)을 0~100으로 재매핑
    private func remapToPercent(value: Int) -> Int {
        // ⚠️ 지금 구조에 맞춘 임시 하드코딩 범위
        let minValue = 16
        let maxValue = 24
        
        guard maxValue > minValue else { return 0 }
        
        let clamped = max(minValue, min(value, maxValue))
        let ratio = Double(clamped - minValue) / Double(maxValue - minValue)
        return Int(ratio * 100)
    }
}
