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
    
    func retrieveMyImjangDetail(noteID id: Int) -> Single<MyImjangDetailModel> {
        return NoteAPI.getMyImjangDetail(id)
            .request(BaseResponse<MyImjangDetailModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func createImjang(param: ImjangRequestDTO) -> Completable {
        return NoteAPI.postImjang(param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func updateImjang(noteID id: Int,
                      param: ImjangUpdateRequestDTO) -> Completable {
        return NoteAPI.patchImjang(id, param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
}
