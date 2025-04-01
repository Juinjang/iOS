//
//  SearchKeywordSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 3/29/25.
//

import RxDataSources

struct SearchKeywordSectionModel {
    var items: [String]
}

extension SearchKeywordSectionModel: SectionModelType {
    typealias Identity = String
    typealias Item = String

    var identity: String {
        return "search_section"
    }

    init(original: SearchKeywordSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
