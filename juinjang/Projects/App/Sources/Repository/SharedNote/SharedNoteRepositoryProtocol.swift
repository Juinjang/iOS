//
//  SharedNoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import RxSwift

protocol SharedNoteRepositoryProtocol {
    func retrieveMyNotes(param: MyNoteRequestDTO) -> Single<[MyNoteModel]>
    func retrieveExploreNotes(param: ExploreNoteRequestDTO) -> Single<ExploreNoteResponseDTO>
    func retrieveNoteDetail(noteID id: Int) -> Single<ImjangDetailInfoModel>
    func retrieveNoteDetailReport(noteId id: Int) -> Single<ImjangDetailReportModel>
    func retrieveNoteDetailCheckList(noteId id: Int) -> Single<ImjangDetailCheckListDTO>
    func createNoteLike(noteID id: Int) -> Single<NoteLikeDTO>
    func createSharedNote(noteID id: Int, param: NoteShareRequestDTO) -> Single<NoResultResponse>
    func purchaseNote(noteID id: Int) -> Completable
    func createNoteReport(param: NoteReportRequestDTO) -> Completable
    func deleteNoteLike(noteID id: Int) -> Single<NoteLikeDTO>
    func deleteSharedNote(noteID id: Int) -> Completable
}
