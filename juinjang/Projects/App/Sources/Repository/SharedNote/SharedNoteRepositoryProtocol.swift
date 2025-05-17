//
//  SharedNoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import RxSwift

protocol SharedNoteRepositoryProtocol {
    func retrieveMyNotes(param: NoteRequestDTO) -> Single<[MyNoteModel]>
    func retrieveExploreNotes(param: ExploreNoteRequestDTO) -> Single<ExploreNoteResponseDTO>
    func purchaseNote(noteID id: Int) -> Completable
    func createNoteLike(noteID id: Int) -> Single<NoteLikeDTO>
    func deleteNoteLike(noteID id: Int) -> Single<NoteLikeDTO>
    func deleteSharedNote(noteID id: Int) -> Completable
}
