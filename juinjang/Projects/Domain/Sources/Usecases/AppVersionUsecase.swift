//
//  AppVersionUsecase.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift

public final class AppVersionUsecase: AppVersionUsecaseProtocol {
    private let repository: AppVersionRepositoryProtocol

    public init(repository: AppVersionRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchLatestVersion() -> Single<LatestAppVersion> {
        repository.retrieveLatestAppVersion()
    }
}
