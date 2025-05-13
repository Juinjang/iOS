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
    private var jsonDecoder: JSONDecoder
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared,
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.networkManager = networkManager
        self.userDefault = userDefault
        self.jsonDecoder = jsonDecoder
    }
    
    func getMyNotes(param: NoteRequestDTO) -> Single<[MyNoteModel]> {
        return NoteAPI.getMyNotes(param)
            .request(BaseResponse<NoteListDTO<MyNoteModel>>.self, networkManager)
            .map { $0.result?.notes ?? [] }
    }
    
    func getShareableMyNotes() -> Single<[ShareSelectModel]> {
        return NoteAPI.getShareableNotes
            .request(NoteListDTO<ShareSelectModel>.self, networkManager)
            .map { $0.notes }
    }
}
