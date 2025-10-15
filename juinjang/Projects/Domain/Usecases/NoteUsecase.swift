//
//  NoteUsecase.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import DomainModel
import DomainUsecaseInterfaces
import DomainRepositoryInterfaces

public final class NoteUsecase: NoteUsecaseProtocol {
    private let repository: NoteRepositoryProtocol

    public init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchNotes(sort: String, keyword: String) -> Single<[Note]> {
        repository.retrieveNoteList(sort: sort, keyword: keyword)
    }
    
    public func fetchShareableNotes(_ param: SearchShareableNote) -> Single<[ShareableNoteSelect]> {
        repository.retrieveShareableNoteList(param: param)
    }
    
    public func fetchChecklistConditions(noteId: Int) -> Single<ShareableNoteConditionResult> {
        repository.retrieveChecklistConditionList(noteID: noteId)
    }
    
    public func fetchChecklistAnswers(noteId: Int) -> Single<[NoteCheckListAnswer]> {
        repository.retrieveCheckList(noteID: noteId)
    }
    
    public func fetchNoteDetail(noteId: Int) -> Single<NoteDetail> {
        repository.retrieveNoteDetail(noteID: noteId)
    }

    public func createNote(_ param: AddNote) -> Single<NoteAddCompleted> {
        repository.createNote(param: param)
    }
    
    public func submitChecklistAnswers(noteId: Int, _ params: [AddNoteCheckListAnswer]) -> Single<NoteCheckListAnswerEvaluationReport> {
        repository.createCheckList(noteID: noteId, params: params)
    }
    
    public func updateNote(noteId: Int, _ param: EditNote) -> Completable {
        repository.updateNote(noteID: noteId, param: param)
    }
}
