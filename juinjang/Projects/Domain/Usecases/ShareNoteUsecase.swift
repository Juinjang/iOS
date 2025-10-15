//
//  ShareNoteUsecase.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import DomainModel
import DomainUsecaseInterfaces
import DomainRepositoryInterfaces

public final class ShareNoteUsecase: ShareNoteUsecaseProtocol {
    
    private let repository: ShareNoteRepositoryProtocol
    
    public init(repository: ShareNoteRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchMyNotes(_ param: SearchSharedMyNote) -> Single<[SharedMyNote]> {
        repository.retrieveMyNotes(param: param)
    }
    
    public func searchSharedNotes(_ param: SearchSharedNote) -> Single<SharedNoteSearchCompletedResult> {
        repository.retrieveExploreNotes(param: param)
    }
    
    public func fetchNoteDetail(id: Int) -> Single<SharedNoteDetailInfo> {
        repository.retrieveNoteDetail(noteID: id)
    }
    
    public func fetchNoteReport(id: Int) -> Single<SharedNoteDetailEvaluationReport> {
        repository.retrieveNoteDetailReport(noteId: id)
    }
    
    public func fetchNoteChecklist(id: Int) -> Single<SharedNoteDetailCheckListResult> {
        repository.retrieveNoteDetailCheckList(noteId: id)
    }
    
    public func likeNote(id: Int) -> Single<SharedNoteLikeCompleted> {
        repository.createNoteLike(noteID: id)
    }
    
    public func shareNote(id: Int, with param: AddShareableNote) -> Single<ShareableNoteShareCompleted> {
        repository.createSharedNote(noteID: id, param: param)
    }
    
    public func purchaseNote(id: Int) -> Completable {
        repository.purchaseNote(noteID: id)
    }
    
    public func submitNoteReport(_ param: AddSharedNoteReport) -> Completable {
        repository.createNoteReport(param: param)
    }
    
    public func unlikeNote(id: Int) -> Single<NoteLikeDTO> {
        repository.deleteNoteLike(noteID: id)
    }
    
    public func deleteSharedNote(id: Int) -> Completable {
        repository.deleteSharedNote(noteID: id)
    }
}
