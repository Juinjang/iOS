//
//  PencilShopRepository.swift
//  juinjang
//
//  Created by 조유진 on 5/12/25.
//

import RxSwift
import Foundation
import StoreKit
import Data
import Domain

final class PencilShopRepository: PencilShopRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager

    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrievePencilTotalBalance() -> Single<PencilBalance> {
        return PencilShopAPI.getPencilBalance
            .request(BaseResponse<PencilBalanceResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func purchasePencil(parameter: AddPurchasePencil) -> Single<PurchasePencil> {
        return PencilShopAPI.purchasePencil(parameter)
            .request(BaseResponse<PurchasePencilResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func readAcquiredPencil(acquiredPencilId: Int) -> Single<ReadAcquiredPencil> {
        return PencilShopAPI.readPencil(acquiredPencilId: acquiredPencilId)
            .request(BaseResponse<ReadAcquiredPencilResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveUsedPencil() -> Single<[UsedPencil]> {
        return PencilShopAPI.getUsedPencil
            .request(BaseResponse<[UsedPencilResponse]>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrievePurchasedPencil() -> Single<[PurchasedPencil]> {
        return PencilShopAPI.getPurchasedPencil
            .request(BaseResponse<[PurchasedPencilResponse]>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveAcquiredPencil() -> Single<[AcquiredPencil]> {
        return PencilShopAPI.getAcquiredPencil
            .request(BaseResponse<[AcquiredPencilResponse]>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func retrieveIsTotalReadAcquiredPencil() -> Single<IsTotalReadAcquiredPencil> {
        return PencilShopAPI.getIsTotalReadAcquiredPencil
            .request(BaseResponse<IsTotalReadAcquiredPencilResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
}

