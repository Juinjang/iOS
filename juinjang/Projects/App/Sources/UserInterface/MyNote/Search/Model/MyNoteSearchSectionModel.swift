//
//  MyNoteSearchSectionModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import RxDataSources

struct MyNoteSearchSectionModel {
    var items: [MyNoteCellModel]
}

extension MyNoteSearchSectionModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = MyNoteCellModel
    
    var identity: String {
        return "search_section"
    }

    init(original: MyNoteSearchSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
