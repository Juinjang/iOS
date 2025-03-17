//
//  MyNoteSectionModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/17/25.
//

import RxDataSources

enum MyNoteSectionItem {
    case notice(MyNoteCategoryType)
    case note(MyNoteModel)
}

enum MyNoteSectionModel {
    case notice(items: [MyNoteSectionItem])
    case myNotes(items: [MyNoteSectionItem])
}

extension MyNoteSectionModel: SectionModelType {
    typealias Item = MyNoteSectionItem

    var items: [Item] {
        switch self {
        case .notice(let items):
            return items
        case .myNotes(let items):
            return items
        }
    }

    init(original: MyNoteSectionModel, items: [Item]) {
        switch original {
        case .notice:
            self = .notice(items: items)
        case .myNotes:
            self = .myNotes(items: items)
        }
    }
}
