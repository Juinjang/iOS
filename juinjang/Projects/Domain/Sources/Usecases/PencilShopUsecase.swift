import RxSwift

public final class PencilShopUsecase: PencilShopUseCaseProtocol {
    private let repository: PencilShopRepositoryProtocol

    public init(repository: PencilShopRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchTotalBalance() -> Single<PencilBalance> {
        repository.retrievePencilTotalBalance()
    }

    public func purchasePencil(_ param: AddPurchasePencil) -> Single<PurchasePencil> {
        repository.purchasePencil(parameter: param)
    }

    public func readAcquiredPencil(id: Int) -> Single<ReadAcquiredPencil> {
        repository.readAcquiredPencil(acquiredPencilId: id)
    }

    public func fetchUsedPencils() -> Single<[UsedPencil]> {
        repository.retrieveUsedPencil()
    }

    public func fetchPurchasedPencils() -> Single<[PurchasedPencil]> {
        repository.retrievePurchasedPencil()
    }

    public func fetchAcquiredPencils() -> Single<[AcquiredPencil]> {
        repository.retrieveAcquiredPencil()
    }

    public func isAllAcquiredPencilRead() -> Single<IsTotalReadAcquiredPencil> {
        repository.retrieveIsTotalReadAcquiredPencil()
    }
}
