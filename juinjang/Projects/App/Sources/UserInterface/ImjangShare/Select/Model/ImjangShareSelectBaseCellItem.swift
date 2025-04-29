//
//  ImjangShareSelectBaseCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

enum ImjangShareSelectBaseCellItem: Hashable {
    case guide(ImjangShareSelectGuideCellItem)
    case notice(ImjangShareSelectNoticeCellItem)
    case select(ImjangShareSelectCellItem)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .guide(let item):
            hasher.combine("guide")
            hasher.combine(item)
        case .notice(let item):
            hasher.combine("notice")
            hasher.combine(item)
        case .select(let item):
            hasher.combine("select")
            hasher.combine(item)
            hasher.combine(item.isSelected)
        }
    }
    
    static func ==(lhs: ImjangShareSelectBaseCellItem,
                   rhs: ImjangShareSelectBaseCellItem) -> Bool {
        switch (lhs, rhs) {
        case (.guide(let l), .guide(let r)):
            return l.id == r.id
        case (.notice(let l), .notice(let r)):
            return l.id == r.id
        case (.select(let l), .select(let r)):
            return l.id == r.id &&
            l.isSelected == r.isSelected
        default:
            return false
        }
    }
}
