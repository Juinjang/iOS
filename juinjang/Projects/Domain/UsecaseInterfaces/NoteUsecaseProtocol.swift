//
//  NoteUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import DomainModel

public protocol NoteUsecaseProtocol {
    func fetchNotes(sort: String, keyword: String) -> Single<[Note]>
    func fetchShareableNotes(_ param: SearchShareableNote) -> Single<[ShareableNoteSelect]>
    func fetchChecklistConditions(noteId: Int) -> Single<ShareableNoteConditionResult>
    func fetchChecklistAnswers(noteId: Int) -> Single<[NoteCheckListAnswer]>
    func fetchNoteDetail(noteId: Int) -> Single<NoteDetail>

    func createNote(_ param: AddNote) -> Single<NoteAddCompleted>
    func submitChecklistAnswers(noteId: Int, _ params: [AddNoteCheckListAnswer]) -> Single<NoteCheckListAnswerEvaluationReport>
    func updateNote(noteId: Int, _ param: EditNote) -> Completable
}
