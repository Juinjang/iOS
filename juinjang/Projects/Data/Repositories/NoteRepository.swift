//
//  NoteRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import RxSwift
import DomainRepositoryInterfaces
import DataNetwork
import DataModel
import DomainModel
import DataStorage

final class NoteRepository: NoteRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveNoteList(sort: String,
                          keyword: String) -> Single<[Note]> {
        return NoteAPI.getNoteList(sort: sort, keyword: keyword)
            .request(BaseResponse<NoteListResultResponse<NoteResponse>>.self, networkManager)
            .map { try $0.unwrap().notes }
            .map { $0.toDomain() }
    }
    
    func retrieveShareableNoteList(param: SearchShareableNote) -> Single<[ShareableNoteSelect]> {
        return NoteAPI.getShareableNoteList(param)
            .request(BaseResponse<NoteListResultResponse<ShareableNoteSelectResponse>>.self, networkManager)
            .map { try $0.unwrap().notes }
            .map { $0.toDomain() }
    }
    
    func retrieveChecklistConditionList(noteID id: Int) -> Single<ShareableNoteConditionResult> {
        return NoteAPI.getNoteChecklistConditionList(id)
            .request(BaseResponse<ShareableNoteConditionResultResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveCheckList(noteID id: Int) -> Single<[NoteCheckListAnswer]> {
        return NoteAPI.getNoteChecklist(id)
            .request(BaseResponse<[NoteCheckListAnswerResponse]>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveNoteDetail(noteID id: Int) -> Single<NoteDetail> {
        return NoteAPI.getNoteDetail(id)
            .request(BaseResponse<NoteDetailResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveMainNotes() -> Single<RecentUpdatedNoteResult> {
        return NoteAPI.getMainNotes
            .request(BaseResponse<RecentUpdatedNoteResultResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveMainNoteDetail(noteID: Int) -> Single<MainNoteDetail> {
        return NoteAPI.getMainNoteDetail(noteID: noteID)
            .request(BaseResponse<MainNoteDetailResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func createNote(param: AddNote) -> Single<NoteAddCompleted> {
        return NoteAPI.postNote(param)
            .request(BaseResponse<NoteAddCompletedResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func createCheckList(noteID id: Int,
                         params: [AddNoteCheckListAnswer]) -> Single<NoteCheckListAnswerEvaluationReport> {
        return NoteAPI.postCheckList(id, params)
            .request(BaseResponse<NoteCheckListAnswerEvaluationReportResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func updateNote(noteID id: Int,
                    param: EditNote) -> Completable {
        return NoteAPI.patchNote(id, param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
}
