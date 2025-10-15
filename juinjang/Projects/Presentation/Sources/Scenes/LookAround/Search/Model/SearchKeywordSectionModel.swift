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

extension SearchKeywordSectionModel: SectionModelType, Hashable, Equatable {
    typealias Identity = String
    typealias Item = String

    init(original: SearchKeywordSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
