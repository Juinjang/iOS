//
//  MyNoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 3/16/25.
//

import RxSwift



protocol MyNoteRepositoryProtocol {
    func fetchMyNotes(category: MyNoteCategoryType,
                      offset: Int,
                      limit: Int) -> Observable<[MyNoteModel]>
}

extension MyNoteRepositoryProtocol {
    func fetchMyNotes(category: MyNoteCategoryType = .share,
                      offset: Int = 0,
                      limit: Int = 20) -> Observable<[MyNoteModel]> {
        fetchMyNotes(category: category, offset: offset, limit: limit)
    }
}
