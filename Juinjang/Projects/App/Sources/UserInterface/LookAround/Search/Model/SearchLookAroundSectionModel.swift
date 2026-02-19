//
//  SearchLookAroundSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 3/30/25.
//

import RxDataSources

enum LookAroundSearchResultSectionModel: SectionModelType, Hashable, Equatable {
    typealias ITEM = Row
    
    case imjangCountSection(items: [Row])
    case exploreNoteSection(header: String, items: [Row])

    enum Row: Hashable, Equatable {
        case imjangCountSection(imjangCount: Int)
        case exploreNoteSection(exploreNote: ExploreNoteModel)
    }

    var items: [Row] {
        switch self {
            case .imjangCountSection(let items): return items
            case .exploreNoteSection(_, let items): return items
        }
    }

    init(original: LookAroundSearchResultSectionModel, items: [Row]) {
    switch original {
    case .imjangCountSection(_):
        self = .imjangCountSection(items: items)

    case .exploreNoteSection(let header, _):
        self = .exploreNoteSection(header: header, items: items)
    }
  }
 }
