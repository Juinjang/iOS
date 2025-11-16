import RxSwift

public protocol PencilShopRepositoryProtocol {
    func retrievePencilTotalBalance() -> Single<PencilBalance>
    func purchasePencil(parameter: AddPurchasePencil) -> Single<PurchasePencil>
    func readAcquiredPencil(acquiredPencilId: Int) -> Single<ReadAcquiredPencil>
    func retrieveUsedPencil() -> Single<[UsedPencil]>
    func retrievePurchasedPencil() -> Single<[PurchasedPencil]>
    func retrieveAcquiredPencil() -> Single<[AcquiredPencil]>
    func retrieveIsTotalReadAcquiredPencil() -> Single<IsTotalReadAcquiredPencil>
}
