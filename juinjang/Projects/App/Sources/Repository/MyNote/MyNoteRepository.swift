//
//  MyNoteRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 3/16/25.
//

import RxSwift

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
}

final class MyNoteRepository: MyNoteRepositoryProtocol {
    private var currentOffset: Int = 0

    func fetchMyNotes(category: MyNoteCategoryType,
                      offset: Int,
                      limit: Int) -> Observable<[MyNoteModel]> {
        currentOffset = offset
        
        switch category {
        case .share:
            return .just(.shareMock)
        case .own:
            return .just(.ownMock)
        case .like:
            return .just(.likeMock)
        }
    }
}

extension [MyNoteModel] {
    static let shareMock: [MyNoteModel] = [
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔"),
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔"),
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔")
    ]
    
    static let ownMock: [MyNoteModel] = [
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔"),
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔"),
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔")
    ]
    
    static let likeMock: [MyNoteModel] = [
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔"),
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔"),
        .init(title: "동백이"),
        .init(title: "용인시"),
        .init(title: "수지구"),
        .init(title: "초당 오피스텔")
    ]
}
