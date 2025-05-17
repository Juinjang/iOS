//
//  SharedNoteRespository.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import RxSwift

final class SharedNoteRespository: SharedNoteRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    
    func retrieveMyNotes(param: NoteRequestDTO) -> Single<[MyNoteModel]> {
        return SharedNoteAPI.getMyNotes(param)
            .request(BaseResponse<[MyNoteModel]>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveExploreNotes(param: ExploreNoteRequestDTO) -> Single<ExploreNoteResponseDTO> {
        return SharedNoteAPI.getExploreNotes(param)
            .request(BaseResponse<ExploreNoteResponseDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func purchaseNote(noteID id: Int) -> Completable {
        return SharedNoteAPI.postPurchaseNote(id)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func createNoteLike(noteID id: Int) -> Single<NoteLikeDTO> {
        return SharedNoteAPI.postLikeNote(id)
            .request(BaseResponse<NoteLikeDTO>.self, networkManager)
            .map { try $0.unwrap() }
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
