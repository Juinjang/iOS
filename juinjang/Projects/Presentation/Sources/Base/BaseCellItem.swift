//
//  BaseCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/12/25.
//

import Foundation

internal class BaseCellItem: Hashable {
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    internal func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    internal static func == (lhs: BaseCellItem, rhs: BaseCellItem) -> Bool {
        lhs.id == rhs.id
    }
}
