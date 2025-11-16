//
//  InAppPurchaseUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 11/16/25.
//

import RxSwift
import StoreKit

public protocol InAppPurchaseUseCaseProtocol {
    func requestProductList() -> Single<[Product]>
    func requestPurchase(product: Product) -> Single<PurchasePencil?>
}
