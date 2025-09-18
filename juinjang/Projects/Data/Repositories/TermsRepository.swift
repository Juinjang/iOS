//
//  TermsRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 7/26/25.
//

import Foundation
import RxSwift
import DomainRepositoryInterfaces
import DataNetwork
import DataStorage

final class TermsRepository: TermsRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrievePencilShopAgreementStatus() -> Single<PencilShopAgreementDTO> {
        return TermsAPI.getPencilShopAgreementStatus
            .request(BaseResponse<PencilShopAgreementDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func createTermsAgreement(param: TermsAgreementRequestDTO) -> Single<TermsResponseDTO> {
        return TermsAPI.postTermsAgreement(param)
            .request(BaseResponse<TermsResponseDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
}
