//
//  PencilShopRepositoryProtocol.swift
//  Data
//
//  Created by KimDongWoo on 9/16/25.
//

public protocol PencilShopRepositoryProtocol {
    func retrievePencilTotalBalance() -> Single<PencilBalanceDTO>
    func purchasePencil(parameter: PurchasePencilRequestDTO) -> Single<PurchasePencilDTO>
    func readAcquiredPencil(acquiredPencilId: Int) -> Single<ReadAcquiredPencilDTO>
    func retrieveUsedPencil() -> Single<[UsedPencilDTO]>
    func retrievePurchasedPencil() -> Single<[PurchasedPencilDTO]>
    func retrieveAcquiredPencil() -> Single<[AcquiredPencilDTO]>
    func retrieveIsTotalReadAcquiredPencil() -> Single<IsTotalReadAcquiredPencilDTO>
}
