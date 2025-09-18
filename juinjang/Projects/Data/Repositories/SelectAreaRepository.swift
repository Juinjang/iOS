//
//  SelectAreaRepository.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import RxSwift
import Alamofire
import DataNetwork
import DomainRepositoryInterfaces

final class SelectAreaRepository: SelectAreaRepositoryProtocol {
    private var networkManager: JuinjangAPIManager

    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchAdmSidoList(param: AreaCodeRequestDTO) -> Single<AreaCodeResponseDTO> {
        return AreaCodeAPI.getAreaCodeSidoList(param)
            .request(AreaCodeResponseDTO.self, networkManager)
    }
    
    func fetchAdmSigunguList(param: AreaCodeRequestDTO) -> Single<AreaCodeResponseDTO> {
        return AreaCodeAPI.getAreaCodeSigunguList(param)
            .request(AreaCodeResponseDTO.self, networkManager)
    }
    
    func fetchAdmDongList(param: AreaCodeRequestDTO) -> Single<AreaCodeResponseDTO> {
        return AreaCodeAPI.getAreaCodeDongList(param)
            .request(AreaCodeResponseDTO.self, networkManager)
    }
}
