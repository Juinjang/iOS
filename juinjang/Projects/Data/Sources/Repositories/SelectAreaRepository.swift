//
//  SelectAreaRepository.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import RxSwift
import Alamofire
import Data
import Domain

final class SelectAreaRepository: SelectAreaRepositoryProtocol {
    private var networkManager: JuinjangAPIManager

    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchAdmSidoList(param: SearchAreaCode) -> Single<AreaCode> {
        return AreaCodeAPI.getAreaCodeSidoList(param)
            .request(AreaCodeResponse.self, networkManager)
            .map { $0.toDomain() }
    }
    
    func fetchAdmSigunguList(param: SearchAreaCode) -> Single<AreaCode> {
        return AreaCodeAPI.getAreaCodeSigunguList(param)
            .request(AreaCodeResponse.self, networkManager)
            .map { $0.toDomain() }
    }
    
    func fetchAdmDongList(param: SearchAreaCode) -> Single<AreaCode> {
        return AreaCodeAPI.getAreaCodeDongList(param)
            .request(AreaCodeResponse.self, networkManager)
            .map { $0.toDomain() }
    }
}
