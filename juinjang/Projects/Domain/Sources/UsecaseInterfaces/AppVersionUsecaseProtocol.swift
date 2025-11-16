//
//  AppVersionUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift

public protocol AppVersionUsecaseProtocol {
    func fetchLatestVersion() -> Single<LatestAppVersion>
}
