//
//  SearchAreaRepository.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import RxSwift
import Alamofire

final class SearchAreaRepository: SearchAreaRepositoryProtocol {
    private var networkManager: JuinjangAPIManager

    init(networkManager: JuinjangAPIManager) {
        self.networkManager = networkManager
    }
    
    func fetchAdmSidoList(param: SearchAreaCode) -> Single<AreaCode> {
        let request = SearchAreaCodeRequest(param)
        return AreaCodeAPI.getAreaCodeSidoList(request)
            .request(AreaCodeResponse.self, networkManager)
            .map { $0.toDomain() }
    }
    
    func fetchAdmSigunguList(param: SearchAreaCode) -> Single<AreaCode> {
        let request = SearchAreaCodeRequest(param)
        return AreaCodeAPI.getAreaCodeSigunguList(request)
            .request(AreaCodeResponse.self, networkManager)
            .map { $0.toDomain() }
    }
    
    func fetchAdmDongList(param: SearchAreaCode) -> Single<AreaCode> {
        let request = SearchAreaCodeRequest(param)
        return AreaCodeAPI.getAreaCodeDongList(request)
            .request(AreaCodeResponse.self, networkManager)
            .map { $0.toDomain() }
    }
}
