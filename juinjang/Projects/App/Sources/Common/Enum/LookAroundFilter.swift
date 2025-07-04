//
//  LookAroundFilter.swift
//  juinjang
//
//  Created by 조유진 on 3/13/25.
//

protocol FilterType {
    var rawValue: String { get }
    var title: String { get }
    var action: FilterActionType { get }
}
protocol FilterActionType {
    
}

enum SortFilter: String, CaseIterable, FilterType {
    case popular = "인기순"
    case lateset = "최신순"
    
    var title: String {
        return self.rawValue
    }
    
    var action: FilterActionType {
        switch self {
        case .popular: SortAction.purchaseAction
        case .lateset: SortAction.latestAction
        }
    }
}

enum TransactionTypeFilter: String, CaseIterable, FilterType {
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
    
    var action: FilterActionType {
        switch self {
        case .total: TransactionTypeAction.totalTransaction
        case .monthlyRent: TransactionTypeAction.monthlyRent
        case .lease: TransactionTypeAction.lease
        case .sale: TransactionTypeAction.sale
        }
    }
}

enum SaleTypeFilter: String, CaseIterable, FilterType {
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
    
    var action: FilterActionType {
        switch self {
        case .totalSale: SaleTypeAction.totalSale
        case .officetel: SaleTypeAction.officetel
        case .apartment: SaleTypeAction.apartment
        case .detachedHouse: SaleTypeAction.detachedHouse
        case .villa: SaleTypeAction.villa
        }
    }
}

enum MyNoteFilter: String, CaseIterable, FilterType {
    case updated = "업데이트순"
    case star = "별점순"
    case created = "등록순"
    
    var title: String {
        return self.rawValue
    }
    
    var action: FilterActionType {
        switch self {
        case .updated: MyNoteAction.updated
        case .star: MyNoteAction.star
        case .created: MyNoteAction.created
        }
    }
    
    var parameterValue: String {
        switch self {
        case .updated: "UPDATED"
        case .star: "STAR"
        case .created: "CREATED"
        }
    }
}

enum MyNoteAction: FilterActionType {
    case updated
    case created
    case star
}

enum SortAction: FilterActionType {
    case latestAction
    case purchaseAction
}

enum TransactionTypeAction: FilterActionType {
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
    
    var toRequestType: String {
        switch self {
        case .totalTransaction:
            return "" // 서버에 빈값 전송
        case .monthlyRent:
            return "MONTHLY_RENT"
        case .lease:
            return "PULL_RENT"
        case .sale:
            return "SALE"
        }
    }
}

enum SaleTypeAction: FilterActionType {
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
    
    var toRequestType: String {
        switch self {
        case .totalSale:
            return "" // 서버에 빈값 전송
        case .officetel:
            return "OFFICE_TEL"
        case .apartment:
            return "APARTMENT"
        case .detachedHouse:
            return "DETACHED_HOUSE"
        case .villa:
            return "VILLA"
        }
    }
}
