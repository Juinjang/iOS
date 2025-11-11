//
//  NoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift
import DomainModel

public protocol NoteRepositoryProtocol {
    func retrieveNoteList(sort: String, keyword: String) -> Single<[Note]>
    func retrieveShareableNoteList(param: SearchShareableNote) -> Single<[ShareableNoteSelect]>
    func retrieveChecklistConditionList(noteID id: Int) -> Single<ShareableNoteConditionResult>
    func retrieveCheckList(noteID id: Int) -> Single<[NoteCheckListAnswer]>
    func retrieveNoteDetail(noteID id: Int) -> Single<NoteDetail>
    func retrieveMainNotes() -> Single<RecentUpdatedNoteResult>
    func retrieveMainNoteDetail(noteID: Int) -> Single<MainNoteDetail>
    func createNote(param: AddNote) -> Single<NoteAddCompleted>
    func createCheckList(noteID id: Int, params: [AddNoteCheckListAnswer]) -> Single<NoteCheckListAnswerEvaluationReport>
    func updateNote(noteID id: Int, param: EditNote) -> Completable
}
