//
//  AppVersionUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import DomainModel

public protocol AppVersionUsecaseProtocol {
    func fetchLatestVersion() -> Single<LatestAppVersion>
}
