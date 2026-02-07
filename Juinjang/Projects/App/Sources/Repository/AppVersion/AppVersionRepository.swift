//
//  AppVersionRepository.swift
//  juinjang
//
//  Created by 조유진 on 8/9/25.
//

import RxSwift

final class AppVersionRepository: AppVersionRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveLatestAppVersion() -> Single<LatestAppVersionDTO> {
        return AppVersionAPI.getLatestAppVersion
            .request(BaseResponse<LatestAppVersionDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
}
