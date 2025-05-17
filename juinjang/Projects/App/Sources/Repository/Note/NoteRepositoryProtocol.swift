//
//  NoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift

protocol NoteRepositoryProtocol {
    func retrieveShareableMyNotes() -> Single<[ShareSelectModel]>
    func retrieveChecklistConditions(noteID id: Int) -> Single<ShareableConditionDTO>
    func retrieveMyImjangDetail(noteID id: Int) -> Single<MyImjangDetailModel>
    func createImjang(param: ImjangRequestDTO) -> Completable
    func updateImjang(noteID id: Int, param: ImjangUpdateRequestDTO) -> Completable
}

