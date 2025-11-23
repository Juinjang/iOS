//
//  TermsRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 7/26/25.
//

import RxSwift

public protocol TermsRepositoryProtocol {
    func retrievePencilShopAgreementStatus() -> Single<PencilShopAgreement>
    func createTermsAgreement(param: AddTermsAgreement) -> Single<TermsAgreement>
}
