//
//  SharedNoteRespository.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import RxSwift

final class SharedNoteRepository: SharedNoteRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveMyNotes(param: MyNoteRequestDTO) -> Single<[MyNoteModel]> {
        return SharedNoteAPI.getMyNoteList(param)
            .request(BaseResponse<[MyNoteModel]>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveExploreNotes(param: ExploreNoteRequestDTO) -> Single<ExploreNoteResponseDTO> {
        return SharedNoteAPI.getExploreNoteList(param)
            .request(BaseResponse<ExploreNoteResponseDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveNoteDetail(noteID id: Int) -> Single<ImjangDetailInfoModel> {
        return SharedNoteAPI.getNoteDetail(id)
            .request(BaseResponse<ImjangDetailInfoModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveNoteDetailReport(noteId id: Int) -> Single<ImjangDetailReportModel> {
        return SharedNoteAPI.getNoteDetailReport(id)
            .request(BaseResponse<ImjangDetailReportModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveNoteDetailCheckList(noteId id: Int) -> Single<ImjangDetailCheckListDTO> {
        return SharedNoteAPI.getNoteDetailChecklist(id)
            .request(BaseResponse<ImjangDetailCheckListDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func purchaseNote(noteID id: Int) -> Completable {
        return SharedNoteAPI.postPurchaseNote(id)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func createSharedNote(noteID id: Int, param: NoteShareRequestDTO) -> Completable {
        return SharedNoteAPI.postSharedNote(id, param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }

    func createNoteLike(noteID id: Int) -> Single<NoteLikeDTO> {
        return SharedNoteAPI.postLikeNote(id)
            .request(BaseResponse<NoteLikeDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func createNoteReport(param: NoteReportRequestDTO) -> Completable {
        return SharedNoteAPI.postNoteReport(param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func deleteNoteLike(noteID id: Int) -> Single<NoteLikeDTO> {
        return SharedNoteAPI.deleteLikeNote(id)
            .request(BaseResponse<NoteLikeDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func deleteSharedNote(noteID id: Int) -> Completable {
        return SharedNoteAPI.deleteSharedNote(id)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
}
