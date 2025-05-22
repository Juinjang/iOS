//
//  SelectAreaRepositoryProtocol.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import RxSwift

protocol SelectAreaRepositoryProtocol {
    func fetchAdmSidoList(param: AdmRequestDTO) -> Single<AdmResponseDto>
    func fetchAdmSigunguList(param: AdmRequestDTO) -> Single<AdmResponseDto>
    func fetchAdmDongList(param: AdmRequestDTO) -> Single<AdmResponseDto>
}
