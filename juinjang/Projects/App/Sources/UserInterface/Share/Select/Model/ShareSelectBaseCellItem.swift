//
//  ImjangShareSelectBaseCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

enum ShareSelectBaseCellItem: Hashable {
    case guide(ShareSelectGuideCellItem)
    case notice(ShareSelectNoticeCellItem)
    case select(ShareSelectCellItem)
    
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
    
    static func ==(lhs: ShareSelectBaseCellItem,
                   rhs: ShareSelectBaseCellItem) -> Bool {
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
