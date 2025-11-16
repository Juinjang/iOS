//
//  ShareNoteUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift

public protocol ShareNoteUsecaseProtocol {
    func fetchMyNotes(_ param: SearchSharedMyNote) -> Single<[SharedMyNote]>
    func searchSharedNotes(_ param: SearchSharedNote) -> Single<SharedNoteSearchCompletedResult>
    func fetchNoteDetail(id: Int) -> Single<SharedNoteDetailInfo>
    func fetchNoteReport(id: Int) -> Single<SharedNoteDetailEvaluationReport>
    func fetchNoteChecklist(id: Int) -> Single<SharedNoteDetailCheckListResult>

    func likeNote(id: Int) -> Single<SharedNoteLikeCompleted>
    func shareNote(id: Int, with param: AddShareableNote) -> Single<ShareableNoteShareCompleted>
    func purchaseNote(id: Int) -> Completable
    func submitNoteReport(_ param: AddSharedNoteReport) -> Completable

    func unlikeNote(id: Int) -> Single<SharedNoteLikeCompleted>
    func deleteSharedNote(id: Int) -> Completable
}
