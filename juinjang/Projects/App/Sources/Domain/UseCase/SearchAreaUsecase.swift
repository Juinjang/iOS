//
//  SearchAreaUsecase.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import RxSwift

public final class SearchAreaUsecase: SearchAreaUsecaseProtocol {
    private let repository: SearchAreaRepositoryProtocol

    public init(repository: SearchAreaRepositoryProtocol) {
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
