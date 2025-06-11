//
//  NoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift

protocol NoteRepositoryProtocol {
    func retrieveNoteList(sort: String, keyword: String) -> Single<[NoteDTO]>
    func retrieveShareableNoteList(param: ShareableNoteRequestDTO) -> Single<[ShareSelectModel]>
    func retrieveChecklistConditionList(noteID id: Int) -> Single<ShareableConditionDTO>
    func retrieveCheckList(noteID id: Int) -> Single<[CheckListAnswerDTO]>
    func retrieveNoteDetail(noteID id: Int) -> Single<NoteDetailModel>
    func createNote(param: NoteCreateRequestDTO) -> Single<PostNoteResponseModel>
    func createCheckList(noteID id: Int, params: [CheckListRequestDto]) -> Single<CheckListReportResult>
    func updateNote(noteID id: Int, param: NoteUpdateRequestDTO) -> Completable
}
