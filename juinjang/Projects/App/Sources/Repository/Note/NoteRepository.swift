//
//  NoteRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import RxSwift

final class NoteRepository: NoteRepositoryProtocol {
    private var networkProvider: NetworkProvider<NoteAPI>
    private var userDefault: UserDefaultManager
    private var jsonDecoder: JSONDecoder
    
    init(networkProvider: NetworkProvider<NoteAPI>,
         userDefault: UserDefaultManager,
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.networkProvider = networkProvider
        self.userDefault = userDefault
        self.jsonDecoder = jsonDecoder
    }
    
    func getMyNotes() -> Single<[MyNoteModel]> {
        return NoteAPI.getMyNotes
            .request(networkProvider)
            .mapResult([MyNoteModel].self, using: jsonDecoder)
    }
    
    func getShareableMyNotes() -> Single<[ImjangShareSelectModel]> {
        return NoteAPI.getShareableNotes
            .request(networkProvider)
            .mapResult([ImjangShareSelectModel].self, using: jsonDecoder)
    }
}
