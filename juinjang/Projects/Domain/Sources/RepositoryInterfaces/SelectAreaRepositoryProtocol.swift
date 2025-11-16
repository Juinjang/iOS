//
//  SelectAreaRepositoryProtocol.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import RxSwift

public protocol SelectAreaRepositoryProtocol {
    func fetchAdmSidoList(param: SearchAreaCode) -> Single<AreaCode>
    func fetchAdmSigunguList(param: SearchAreaCode) -> Single<AreaCode>
    func fetchAdmDongList(param: SearchAreaCode) -> Single<AreaCode>
}
