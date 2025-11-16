//
//  AppVersionRepositoryProtocol.swift
//  juinjang
//
//  Created by 조유진 on 8/9/25.
//

import RxSwift
import Domain

public protocol AppVersionRepositoryProtocol {
    func retrieveLatestAppVersion() -> Single<LatestAppVersion>
}
