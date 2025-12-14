//
//  OnboardingRepositoryProtocol.swift
//  App
//
//  Created by KimDongWoo on 12/13/25.
//

import RxSwift

protocol OnboardingRepositoryProtocol {
    func retrieveRecentNotes() -> Single<RecentUpdatedDto>
    func retrieveMyNotes() -> Single<[NoteDTO]>
    func retrieveMyNoteCheckLists() -> Single<[CheckListAnswerDTO]>
    func retrieveMyNoteDetail() -> Single<NoteDetailModel>
    func retrieveMyNoteRecordMemo() -> Single<RecordMemoDto>
}
