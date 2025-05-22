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
}
