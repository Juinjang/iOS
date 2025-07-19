//
//  MyNotePageModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/17/25.
//

import RxDataSources

struct MyNotePageModel: Equatable {
    var category: MyNoteCategoryType
    var isShowingNotice: Bool
    var transactionType: TransactionTypeFilter
    var saleType: SaleTypeFilter
    var items: [MyNoteCellModel]
    var isFirstShowing: Bool
    
    static func == (lhs: MyNotePageModel,
                    rhs: MyNotePageModel) -> Bool {
        return lhs.category == rhs.category &&
        lhs.isShowingNotice == rhs.isShowingNotice &&
        lhs.transactionType == rhs.transactionType &&
        lhs.saleType == rhs.saleType &&
        lhs.items == rhs.items
    }
}

extension MyNotePageModel: AnimatableSectionModelType {
    typealias Item = MyNoteCellModel
    typealias Identity = String

    var identity: String {
        return "\(category.rawValue)"
    }

    init(original: MyNotePageModel, items: [Item]) {
        self = original
        self.items = items
    }
}
