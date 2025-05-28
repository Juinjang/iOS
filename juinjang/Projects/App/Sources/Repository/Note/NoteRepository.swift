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
    
    func retrieveShareableNoteList() -> Single<[ShareSelectModel]> {
        return NoteAPI.getShareableNoteList
            .request(BaseResponse<NoteListDTO<ShareSelectModel>>.self, networkManager)
            .map { try $0.unwrap().notes }
    }
    
    func retrieveChecklistConditionList(noteID id: Int) -> Single<ShareableConditionDTO> {
        return NoteAPI.getNoteChecklistConditionList(id)
            .request(BaseResponse<ShareableConditionDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveCheckList(noteID id: Int) -> Single<[CheckListAnswerModel]> {
        return NoteAPI.getNoteChecklist(id)
            .request(BaseResponse<CheckListAnswerDTO>.self, networkManager)
            .map { try $0.unwrap().checkListAnswerList }
    }
    
    func retrieveNoteDetail(noteID id: Int) -> Single<NoteDetailModel> {
        return NoteAPI.getNoteDetail(id)
            .request(BaseResponse<NoteDetailModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func createNote(param: NoteCreateRequestDTO) -> Single<PostNoteResponseModel> {
        return NoteAPI.postNote(param)
            .request(BaseResponse<PostNoteResponseModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func updateImjang(noteID id: Int,
                      param: NoteUpdateRequestDTO) -> Completable {
        return NoteAPI.patchNote(id, param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func updateNote(noteID id: Int, param: NoteUpdateRequestDTO) -> Completable {
        return NoteAPI.patchNote(id, param)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
}
