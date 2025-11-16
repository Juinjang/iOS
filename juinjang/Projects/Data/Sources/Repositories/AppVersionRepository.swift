//
//  AppVersionRepository.swift
//  juinjang
//
//  Created by 조유진 on 8/9/25.
//

import RxSwift
import Data
import Domain

public final class AppVersionRepository: AppVersionRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveLatestAppVersion() -> Single<LatestAppVersion> {
        return AppVersionAPI.getLatestAppVersion
            .request(BaseResponse<LatestAppVersionResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
}
