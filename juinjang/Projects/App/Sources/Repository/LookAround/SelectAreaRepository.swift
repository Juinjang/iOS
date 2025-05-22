//
//  SelectAreaRepository.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//

import RxSwift
import Alamofire

final class SelectAreaRepository: SelectAreaRepositoryProtocol {
    private let networkManager: JuinjangAPIManager
    
    init(networkManager: JuinjangAPIManager) {
        self.networkManager = networkManager
    }
    
    func fetchAdmSidoList(param: AdmRequestDTO) -> Single<AdmResponseDto> {
        return AreaAPI.getAdmSidoList(param)
            .request(AdmResponseDto.self, networkManager)
    }
    
    func fetchAdmSigunguList(param: AdmRequestDTO) -> Single<AdmResponseDto> {
        return AreaAPI.getAdmSigunguList(param)
            .request(AdmResponseDto.self, networkManager)
    }
    
    func fetchAdmDongList(param: AdmRequestDTO) -> Single<AdmResponseDto> {
        return AreaAPI.getAdmDongList(param)
            .request(AdmResponseDto.self, networkManager)
    }
}
