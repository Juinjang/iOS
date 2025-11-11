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
import RxSwift

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
    
    public func fetchChecklistConditions(noteID: Int) -> Single<ShareableNoteConditionResult> {
        repository.retrieveChecklistConditionList(noteID: noteID)
    }
    
    public func fetchChecklistAnswers(noteID: Int) -> Single<[NoteCheckListAnswer]> {
        repository.retrieveCheckList(noteID: noteID)
    }
    
    public func fetchNoteDetail(noteID: Int) -> Single<NoteDetail> {
        repository.retrieveNoteDetail(noteID: noteID)
    }
    
    public func fetchMainNotes() -> Single<[MainNote]> {
        repository.retrieveMainNotes()
            .map { $0.recentUpdatedNoteList }
    }
    
    public func fetchMainNoteDetail(noteID: Int) -> Single<MainNoteDetail> {
        repository.retrieveMainNoteDetail(noteID: noteID)
    }
    
    public func fetchMainNoteCheckListVersion(noteID: Int) -> Single<Int> {
        repository.retrieveMainNoteDetail(noteID: noteID)
            .map { CheckListVersion.init(from: $0.checkListVersion).rawValue }
    }
    
    public func createNote(_ param: AddNote) -> Single<NoteAddCompleted> {
        repository.createNote(param: param)
    }
    
    public func submitChecklistAnswers(noteID: Int,
                                       _ params: [AddNoteCheckListAnswer]) -> Single<NoteCheckListAnswerEvaluationReport> {
        repository.createCheckList(noteID: noteID, params: params)
    }
    
    public func updateNote(noteID: Int,
                           _ param: EditNote) -> Completable {
        repository.updateNote(noteID: noteID, param: param)
    }
}
