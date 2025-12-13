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
}
