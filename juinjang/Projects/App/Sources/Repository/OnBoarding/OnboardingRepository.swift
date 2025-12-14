//
//  OnboardingRepository.swift
//  App
//
//  Created by KimDongWoo on 12/13/25.
//

import RxSwift

final class OnboardingRepository: OnboardingRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveRecentNotes() -> Single<RecentUpdatedDto> {
        return OnboardingAPI.getRecentNotes
            .request(BaseResponse<RecentUpdatedDto>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveMyNotes() -> Single<[NoteDTO]> {
        return OnboardingAPI.getMyNotes
            .request(BaseResponse<NoteResultDTO>.self, networkManager)
            .map { try $0.unwrap().notes }
    }
    
    func retrieveMyNoteCheckLists() -> Single<[CheckListAnswerDTO]> {
        return OnboardingAPI.getMyNoteCheckLists
            .request(BaseResponse<[CheckListAnswerDTO]>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveMyNoteDetail() -> Single<NoteDetailModel> {
        return OnboardingAPI.getMyNoteDetail
            .request(BaseResponse<NoteDetailModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveMyNoteRecordMemo() -> Single<RecordMemoDto> {
        return OnboardingAPI.getMyNoteRecordMemo
            .request(BaseResponse<RecordMemoDto>.self, networkManager)
            .map { try $0.unwrap() }
    }
}
