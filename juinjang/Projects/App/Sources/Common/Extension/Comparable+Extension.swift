//
//  Comparable+Extension.swift
//  App
//
//  Created by KimDongWoo on 1/24/26.
//

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
