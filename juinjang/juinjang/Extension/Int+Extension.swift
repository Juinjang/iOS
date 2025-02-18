//
//  Int+Extension.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

extension Int {
    static func convertTimeToInt(time: TimeInterval) -> Int? {
        print("녹음된 시간: \(time)")

        return Int(time)
    }
}
