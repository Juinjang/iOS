//
//  TermsRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 7/26/25.
//

import Foundation
import RxSwift

final class TermsRepository: TermsRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrievePencilShopAgreementStatus() -> Single<PencilShopAgreement> {
        return TermsAPI.getPencilShopAgreementStatus
            .request(BaseResponse<PencilShopAgreementResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func createTermsAgreement(param: AddTermsAgreement) -> Single<TermsAgreement> {
        let request = AddTermsAgreementRequest(param)
        
        return TermsAPI.postTermsAgreement(request)
            .request(BaseResponse<TermsAgreementResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
}
