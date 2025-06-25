//
//  Optional+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 6/22/25.
//

extension Optional where Wrapped == Bool {
    mutating func toggle(or defaultValue: Bool = false) {
        self = !(self ?? defaultValue)
    }
}
