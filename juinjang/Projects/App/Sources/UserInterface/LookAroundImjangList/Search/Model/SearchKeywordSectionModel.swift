//
//  SearchKeywordSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 3/29/25.
//

import RxDataSources

struct LookAroundSearchSectionModel {
    var items: [String]
}

extension LookAroundSearchSectionModel: SectionModelType {
    typealias Identity = String
    typealias Item = String

    var identity: String {
        return "search_section"
    }

    init(original: LookAroundSearchSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
