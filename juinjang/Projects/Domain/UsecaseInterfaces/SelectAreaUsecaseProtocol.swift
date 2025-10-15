//
//  SelectAreaUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import DomainModel

public protocol SelectAreaUsecaseProtocol {
    func fetchSidoList(_ param: SearchAreaCode) -> Single<AreaCode>
    func fetchSigunguList(_ param: SearchAreaCode) -> Single<AreaCode>
    func fetchDongList(_ param: SearchAreaCode) -> Single<AreaCode>
}
