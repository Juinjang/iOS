import DomainUsecaseInterfaces
import DomainRepositoryInterfaces

public final class TermsUseCase: TermsUsecaseProtocol {
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
