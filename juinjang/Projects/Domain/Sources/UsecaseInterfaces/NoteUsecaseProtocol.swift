//
//  NoteUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift

public protocol NoteUsecaseProtocol {
    func fetchNotes(sort: String, keyword: String) -> Single<[Note]>
    func fetchShareableNotes(_ param: SearchShareableNote) -> Single<[ShareableNoteSelect]>
    func fetchChecklistConditions(noteID: Int) -> Single<ShareableNoteConditionResult>
    func fetchChecklistAnswers(noteID: Int) -> Single<[NoteCheckListAnswer]>
    func fetchNoteDetail(noteID: Int) -> Single<NoteDetail>
    func fetchMainNotes() -> Single<[MainNote]>
    func fetchMainNoteDetail(noteID: Int) -> Single<MainNoteDetail>
    func fetchMainNoteCheckListVersion(noteID: Int) -> Single<Int>

    func createNote(_ param: AddNote) -> Single<NoteAddCompleted>
    func submitChecklistAnswers(noteID: Int, _ params: [AddNoteCheckListAnswer]) -> Single<NoteCheckListAnswerEvaluationReport>
    func updateNote(noteID: Int, _ param: EditNote) -> Completable
}
