//
//  LookAroundFilter.swift
//  juinjang
//
//  Created by 조유진 on 3/13/25.
//

protocol LookAroundFilterType {
    var rawValue: String { get }
    var title: String { get }
    var action: LookAroundFilterActionType { get }
}
protocol LookAroundFilterActionType {
    
}

enum SortFilter: String, CaseIterable, LookAroundFilterType {
    case lateset = "최신순"
    case purchase = "구매순"
    
    var title: String {
        return self.rawValue
    }
    
    var action: LookAroundFilterActionType {
        switch self {
        case .lateset: SortAction.latestAction
        case .purchase: SortAction.purchaseAction
        }
    }
}

enum TransactionTypeFilter: String, CaseIterable, LookAroundFilterType {
    case total = "전체"
    case monthlyRent = "월세"
    case lease = "전세"
    case sale = "매매"
    
    var title: String {
        switch self {
        case .total: "거래 전체"
        case .monthlyRent, .lease, .sale: self.rawValue
        }
    }
    
    var action: LookAroundFilterActionType {
        switch self {
        case .total: TransactionTypeAction.totalTransaction
        case .monthlyRent: TransactionTypeAction.monthlyRent
        case .lease: TransactionTypeAction.lease
        case .sale: TransactionTypeAction.sale
        }
    }
}

enum SaleTypeFilter: String, CaseIterable, LookAroundFilterType {
    case totalSale = "전체"
    case officetel = "오피스텔"
    case apartment = "아파트"
    case detachedHouse = "단독 주택"
    case villa = "빌라"
    
    var title: String {
        switch self {
        case .totalSale: "매물 전체"
        case .officetel, .apartment, .detachedHouse, .villa: self.rawValue
        }
    }
    
    var action: LookAroundFilterActionType {
        switch self {
        case .totalSale: SaleTypeAction.totalSale
        case .officetel: SaleTypeAction.officetel
        case .apartment: SaleTypeAction.apartment
        case .detachedHouse: SaleTypeAction.detachedHouse
        case .villa: SaleTypeAction.villa
        }
    }
}

enum SortAction: LookAroundFilterActionType {
    case latestAction
    case purchaseAction
}

enum TransactionTypeAction: LookAroundFilterActionType {
    case totalTransaction
    case monthlyRent
    case lease
    case sale
    
    var filter: TransactionTypeFilter {
        switch self {
        case .totalTransaction:
            return .total
        case .monthlyRent:
            return .monthlyRent
        case .lease:
            return .lease
        case .sale:
            return .sale
        }
    }
}

enum SaleTypeAction: LookAroundFilterActionType {
    case totalSale
    case officetel
    case apartment
    case detachedHouse
    case villa
    
    var filter: SaleTypeFilter {
        switch self {
        case .totalSale:
            return .totalSale
        case .officetel:
            return .officetel
        case .apartment:
            return .apartment
        case .detachedHouse:
            return .detachedHouse
        case .villa:
            return .villa
        }
    }
}
