//
//  Double+Extension.swift
//  juinjang
//
//  Created by 조유진 on 8/20/24.
//

import Foundation

extension Double {
    func truncateToSingleDecimal() -> Double {
        return floor(self * 10) / 10
    }
    
    func convertTo1fString() -> String {
        return String(format: "%.1f", self)
    }
}
