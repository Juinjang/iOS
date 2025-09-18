//
//  SelectAreaRepositoryProtocol.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import RxSwift

public protocol SelectAreaRepositoryProtocol {
    func fetchAdmSidoList(param: AreaCodeRequestDTO) -> Single<AreaCodeResponseDTO>
    func fetchAdmSigunguList(param: AreaCodeRequestDTO) -> Single<AreaCodeResponseDTO>
    func fetchAdmDongList(param: AreaCodeRequestDTO) -> Single<AreaCodeResponseDTO>
}
