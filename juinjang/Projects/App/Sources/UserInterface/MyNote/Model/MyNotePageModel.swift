//
//  MyNotePageModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/17/25.
//

import RxDataSources

struct MyNotePageModel {
    var category: MyNoteCategoryType
    var items: [MyNoteModel]
}

extension MyNotePageModel: SectionModelType {
    typealias Item = MyNoteModel

    init(original: MyNotePageModel, items: [Item]) {
        self = original
        self.items = items
    }
}
