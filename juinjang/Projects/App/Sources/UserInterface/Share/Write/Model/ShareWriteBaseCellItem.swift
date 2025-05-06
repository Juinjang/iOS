//
//  ShareWriteBaseCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

enum ShareWriteBaseCellItem: Hashable {
    case notice(ShareWriteNoticeCellItem)
    case share(ShareWriteShareCellItem)
    case building(ShareWriteBuildingCellItem)
    case photo(ShareWritePhotoCellItem)
    case time(ShareWriteTimeCellItem)
    case review(ShareWriteReviewCellItem)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .notice:
            hasher.combine("notice")
        case .share:
            hasher.combine("share")
        case .building:
            hasher.combine("building")
        case .photo:
            hasher.combine("photo")
        case .time:
            hasher.combine("time")
        case .review:
            hasher.combine("review")
        }
    }
    
    static func ==(lhs: ShareWriteBaseCellItem,
                   rhs: ShareWriteBaseCellItem) -> Bool {
        switch (lhs, rhs) {
        case (.notice(let l), .notice(let r)):
            return l.id == r.id
        case (.share(let l), .share(let r)):
            return l.id == r.id
        case (.building(let l), .building(let r)):
            return l.id == r.id
        case (.photo(let l), .photo(let r)):
            return l.id == r.id &&
            l.isPublic == r.isPublic
        case (.time(let l), .time(let r)):
            return l.id == r.id &&
            l.periodModel == r.periodModel
        case (.review(let l), .review(let r)):
            return l.id == r.id
        default:
            return false
        }
    }
}
