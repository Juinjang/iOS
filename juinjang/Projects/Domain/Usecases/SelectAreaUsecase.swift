//
//  SelectAreaUsecase.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import DomainModel
import DomainUsecaseInterfaces
import DomainRepositoryInterfaces

public final class SelectAreaUsecase: SelectAreaUsecaseProtocol {
    private let repository: SelectAreaRepositoryProtocol

    public init(repository: SelectAreaRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchSidoList(_ param: SearchAreaCode) -> Single<AreaCode> {
        repository.fetchAdmSidoList(param: param)
    }
    
    public func fetchSigunguList(_ param: SearchAreaCode) -> Single<AreaCode> {
        repository.fetchAdmSigunguList(param: param)
    }
    
    public func fetchDongList(_ param: SearchAreaCode) -> Single<AreaCode> {
        repository.fetchAdmDongList(param: param)
    }
}
