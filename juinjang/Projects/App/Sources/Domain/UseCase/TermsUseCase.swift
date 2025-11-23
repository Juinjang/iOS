//
//  TermsUseCase.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import RxSwift

public final class TermsUseCase: TermsUseCaseProtocol {
    private let repository: TermsRepositoryProtocol

    public init(repository: TermsRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchPencilShopAgreementStatus() -> Single<PencilShopAgreement> {
        repository.retrievePencilShopAgreementStatus()
    }

    public func addTermsAgreement(_ param: AddTermsAgreement) -> Single<TermsAgreement> {
        repository.createTermsAgreement(param: param)
    }
}
