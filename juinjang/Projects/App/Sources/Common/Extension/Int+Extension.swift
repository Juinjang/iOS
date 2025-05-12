//
//  Int+Extension.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

extension Int {
    static func convertTimeToInt(time: TimeInterval) -> Int? {
        return Int(time)
    }
    
    // 추후 로직 적용 추가
    var monthAgoString: String {
        return "\(self)개월 전"
    }

    func convertHitsString() -> String {
        return self > 999 ? "999+" : "\(self)"
    }
}
