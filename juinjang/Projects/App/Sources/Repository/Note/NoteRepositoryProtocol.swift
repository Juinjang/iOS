//
//  NoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift

protocol NoteRepositoryProtocol {
    func retrieveNoteList(sort: String, keyword: String) -> Single<[MyImjangResponseDTO]>
    func retrieveShareableNoteList() -> Single<[ShareSelectModel]>
    func retrieveChecklistConditionList(noteID id: Int) -> Single<ShareableConditionDTO>
    func retrieveCheckList(noteID id: Int) -> Single<[CheckListAnswerModel]>
    func retrieveNoteDetail(noteID id: Int) -> Single<NoteDetailModel>
    func createNote(param: NoteCreateRequestDTO) -> Single<PostNoteResponseModel>
    func updateNote(noteID id: Int, param: NoteUpdateRequestDTO) -> Completable
}

