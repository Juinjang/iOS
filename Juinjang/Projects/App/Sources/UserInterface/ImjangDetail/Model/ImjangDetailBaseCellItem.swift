//
//  ImjangDetailBaseCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/23/25.
//

enum ImjangDetailBaseCellItem: Hashable {
    case info(ImjangDetailInfoCellItem)
    case report(ImjangDetailReportCellItem)
    case checkList(ImjangDetailCheckListCellItem)
    case review(ImjangDetailReviewCellItem)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .info(let item):
            hasher.combine("info")
            hasher.combine(item)
        case .report(let item):
            hasher.combine("report")
            hasher.combine(item)
        case .checkList(let item):
            hasher.combine("checkList")
            hasher.combine(item)
        case .review(let item):
            hasher.combine("review")
            hasher.combine(item)
        }
    }

    static func ==(lhs: ImjangDetailBaseCellItem, rhs: ImjangDetailBaseCellItem) -> Bool {
        switch (lhs, rhs) {
        case (.info(let l), .info(let r)):
            return l.id == r.id &&
            l.model.isLiked == r.model.isLiked &&
            l.model.isBuyer == r.model.isBuyer
        case (.report(let l), .report(let r)):
            return l.id == r.id
        case (.checkList(let l), .checkList(let r)):
            return l.id == r.id
        case (.review(let l), .review(let r)):
            return l.id == r.id
        default:
            return false
        }
    }
}
