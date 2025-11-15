//
//  SharedNoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import RxSwift
import DomainModel

public protocol ShareNoteRepositoryProtocol {
    func retrieveMyNotes(param: SearchSharedMyNote) -> Single<[SharedMyNote]>
    func retrieveExploreNotes(param: SearchSharedNote) -> Single<SharedNoteSearchCompletedResult>
    func retrieveNoteDetail(noteID id: Int) -> Single<SharedNoteDetailInfo>
    func retrieveNoteDetailReport(noteId id: Int) -> Single<SharedNoteDetailEvaluationReport>
    func retrieveNoteDetailCheckList(noteId id: Int) -> Single<SharedNoteDetailCheckListResult>
    func createNoteLike(noteID id: Int) -> Single<SharedNoteLikeCompleted>
    func createSharedNote(noteID id: Int, param: AddShareableNote) -> Single<ShareableNoteShareCompleted>
    func purchaseNote(noteID id: Int) -> Completable
    func createNoteReport(param: AddSharedNoteReport) -> Completable
    func deleteNoteLike(noteID id: Int) -> Single<SharedNoteLikeCompleted>
    func deleteSharedNote(noteID id: Int) -> Completable
}
