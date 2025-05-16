//
//  NoteRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import RxSwift

final class NoteRepository: NoteRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveMyNotes(param: NoteRequestDTO) -> Single<[MyNoteModel]> {
        return NoteAPI.getMyNotes(param)
            .request(BaseResponse<NoteListDTO<MyNoteModel>>.self, networkManager)
            .map { try $0.unwrap().notes }
    }
    
    func retrieveShareableMyNotes() -> Single<[ShareSelectModel]> {
        return NoteAPI.getShareableNotes
            .request(BaseResponse<NoteListDTO<ShareSelectModel>>.self, networkManager)
            .map { try $0.unwrap().notes }
    }
    
    func retrieveChecklistConditions(noteID id: Int) -> Single<ShareableConditionDTO> {
        return NoteAPI.getChecklistConditions(id)
            .request(BaseResponse<ShareableConditionDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func purchaseNote(noteID id: Int) -> Completable {
        return NoteAPI.postPurchaseNote(id)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func createNoteLike(noteID id: Int) -> Single<NoteLikeDTO> {
        return NoteAPI.postLikeNote(id)
            .request(BaseResponse<NoteLikeDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func deleteNoteLike(noteID id: Int) -> Single<NoteLikeDTO> {
        return NoteAPI.deleteLikeNote(id)
            .request(BaseResponse<NoteLikeDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func deleteSharedNote(noteID id: Int) -> Completable {
        return NoteAPI.deleteSharedNote(id)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
}
