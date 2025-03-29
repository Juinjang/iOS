//
//  MyNotePageModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/17/25.
//

import RxDataSources

struct MyNotePageModel {
    var category: MyNoteCategoryType
    var isShowingNotice: Bool
    var transactionType: TransactionTypeFilter
    var saleType: SaleTypeFilter
    var items: [MyNoteCellModel]
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
