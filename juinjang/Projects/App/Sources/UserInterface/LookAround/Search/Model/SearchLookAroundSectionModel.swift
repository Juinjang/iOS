//
//  SearchLookAroundSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 3/30/25.
//

import RxDataSources

enum LookAroundSearchResultSectionModel: SectionModelType {
    typealias ITEM = Row
    
    case imjangCountSection(items: [Row])
    case imjangListSection(header: String, items: [Row])

    enum Row {
        case imjangCountSection(imjangCount: Int)
        case imjangListSection(lookAroundImjang: LookAroundImjangNote)
    }

    var items: [Row] {
        switch self {
            case .imjangCountSection(let items): return items
            case .imjangListSection(_, let items): return items
        }
    }

    init(original: LookAroundSearchResultSectionModel, items: [Row]) {
    switch original {
    case .imjangCountSection(_):
        self = .imjangCountSection(items: items)

    case .imjangListSection(let header, _):
        self = .imjangListSection(header: header, items: items)
    }
  }
 }
