//
//  NoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift

protocol NoteRepositoryProtocol {
    func retrieveMyNotes(param: NoteRequestDTO) -> Single<[MyNoteModel]>
    func retrieveShareableMyNotes() -> Single<[ShareSelectModel]>
    func retrieveChecklistConditions(noteID id: Int) -> Single<ShareableConditionDTO>
    func purchaseNote(noteID id: Int) -> Completable
    func createNoteLike(noteID id: Int) -> Single<NoteLikeDTO>
    func deleteNoteLike(noteID id: Int)  -> Single<NoteLikeDTO>
    func deleteSharedNote(noteID id: Int) -> Completable
}

