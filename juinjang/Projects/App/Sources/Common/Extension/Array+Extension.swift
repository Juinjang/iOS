//
//  Array+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 5/8/25.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
