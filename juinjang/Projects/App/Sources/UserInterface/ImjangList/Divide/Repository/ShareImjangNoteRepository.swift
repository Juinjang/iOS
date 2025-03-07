//
//  ShareImjangNoteRepository.swift
//  juinjang
//
//  Created by 강동영 on 3/7/25.
//

import Foundation
import RxSwift

protocol ShareImjangNoteRepository {
    func fetchNotes(offset: Int, limit: Int) -> Observable<[ListDto]>
}

extension ShareImjangNoteRepository {
    func fetchNotes(offset: Int = 0, limit: Int = 20) -> Observable<[ListDto]> {
        fetchNotes(offset: offset, limit: limit)
    }
}
