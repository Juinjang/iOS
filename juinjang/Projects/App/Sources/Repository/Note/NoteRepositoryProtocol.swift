//
//  NoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift

protocol NoteRepositoryProtocol {
    func getMyNotes(param: NoteRequestDTO) -> Single<[MyNoteModel]>
    func getShareableMyNotes() -> Single<[ShareSelectModel]>
}

