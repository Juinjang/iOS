//
//  TermsUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import DomainModel

public protocol TermsUsecaseProtocol {
    func fetchPencilShopAgreementStatus() -> Single<PencilShopAgreement>
    func addTermsAgreement(_ param: AddTermsAgreement) -> Single<TermsAgreement>
}
