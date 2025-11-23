//
//  SearchAreaUseCaseProtocol.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import RxSwift

public protocol SearchAreaUseCaseProtocol {
    func fetchSidoList(_ param: SearchAreaCode) -> Single<AreaCode>
    func fetchSigunguList(_ param: SearchAreaCode) -> Single<AreaCode>
    func fetchDongList(_ param: SearchAreaCode) -> Single<AreaCode>
}
