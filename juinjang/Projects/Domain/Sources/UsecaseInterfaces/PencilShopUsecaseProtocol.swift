//
//  PencilShopUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift

public protocol PencilShopUseCaseProtocol {
    func fetchTotalBalance() -> Single<PencilBalance>
    func purchasePencil(_ param: AddPurchasePencil) -> Single<PurchasePencil>
    func readAcquiredPencil(id: Int) -> Single<ReadAcquiredPencil>
    func fetchUsedPencils() -> Single<[UsedPencil]>
    func fetchPurchasedPencils() -> Single<[PurchasedPencil]>
    func fetchAcquiredPencils() -> Single<[AcquiredPencil]>
    func isAllAcquiredPencilRead() -> Single<IsTotalReadAcquiredPencil>
}
