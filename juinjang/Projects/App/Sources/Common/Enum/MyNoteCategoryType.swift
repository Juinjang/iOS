//
//  MyNoteCategoryType.swift
//  juinjang
//
//  Created by KimDongWoo on 5/14/25.
//

enum MyNoteCategoryType: Int, CaseIterable {
    case share = 0
    case own = 1
    case like = 2
}

extension MyNoteCategoryType {
    var toText: String {
        switch self {
        case .share:
            return "공유된 노트"
        case .own:
            return "소장한 노트"
        case .like:
            return "좋아한 노트"
        }
    }

    var toRequestType: String {
        switch self {
        case .share:
            return "SHARED"
        case .own:
            return "OWNED"
        case .like:
            return "LIKED"
        }
    }
}
