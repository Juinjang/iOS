//
//  SharedNoteRespository.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import RxSwift
import Data
import Domain

final class ShareNoteRepository: ShareNoteRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    func retrieveMyNotes(param: SearchSharedMyNote) -> Single<[SharedMyNote]> {
        return SharedNoteAPI.getMyNoteList(param)
            .request(BaseResponse<SharedNoteListResultResponse<SharedMyNote>>.self, networkManager)
            .map { try $0.unwrap().notes }
    }
    
    func retrieveExploreNotes(param: SearchSharedNote) -> Single<SharedNoteSearchCompletedResult> {
        return SharedNoteAPI.getExploreNoteList(param)
            .request(BaseResponse<SharedNoteSearchCompletedResultResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveNoteDetail(noteID id: Int) -> Single<SharedNoteDetailInfo> {
        return SharedNoteAPI.getNoteDetail(id)
            .request(BaseResponse<SharedNoteDetailInfo>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveNoteDetailReport(noteId id: Int) -> Single<SharedNoteDetailEvaluationReport> {
        return SharedNoteAPI.getNoteDetailReport(id)
            .request(BaseResponse<SharedNoteDetailEvaluationReportResultResponse>.self, networkManager)
            .map { try $0.unwrap().reportDTO }
            .map { $0.toDomain() }
    }
    
    func retrieveNoteDetailCheckList(noteId id: Int) -> Single<SharedNoteDetailCheckListResult> {
        return SharedNoteAPI.getNoteDetailChecklist(id)
            .request(BaseResponse<SharedNoteDetailCheckListResultResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func purchaseNote(noteID id: Int) -> Completable {
        return SharedNoteAPI.postPurchaseNote(id)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func createSharedNote(noteID id: Int,
                          param: AddShareableNote) -> Single<BaseResponse<SharedNoteResponse>> {
        return SharedNoteAPI.postSharedNote(id, param)
            .request(BaseResponse<SharedNoteResponse>.self, networkManager)
    }

    func createNoteLike(noteID id: Int) -> Single<SharedNoteLikeCompleted> {
        return SharedNoteAPI.postLikeNote(id)
            .request(BaseResponse<SharedNoteLikeCompletedResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func createNoteReport(param: AddSharedNoteReport) -> Completable {
        return SharedNoteAPI.postNoteReport(param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func deleteNoteLike(noteID id: Int) -> Single<SharedNoteLikeCompleted> {
        return SharedNoteAPI.deleteLikeNote(id)
            .request(BaseResponse<SharedNoteLikeCompletedResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func deleteSharedNote(noteID id: Int) -> Completable {
        return SharedNoteAPI.deleteSharedNote(id)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
}
