//
//  TermsRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 7/26/25.
//

import RxSwift

public protocol TermsRepositoryProtocol {
    func retrievePencilShopAgreementStatus() -> Single<PencilShopAgreementDTO>
    func createTermsAgreement(param: TermsAgreementRequestDTO) -> Single<TermsResponseDTO>
}
