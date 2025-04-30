//
//  NoteRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import RxSwift

protocol NoteRepositoryProtocol {
    func getMyNotes() -> Single<[MyNoteModel]>
    func getShareableMyNotes() -> Single<[ImjangShareSelectModel]>
}
