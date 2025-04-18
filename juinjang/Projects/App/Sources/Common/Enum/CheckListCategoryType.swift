//
//  CheckListCategory.swift
//  juinjang
//
//  Created by KimDongWoo on 4/17/25.
//

enum CheckListCategoryType: Int, CaseIterable {
    case LOCATION_CONDITION
    case INDOOR
    case PUBLIC_SPACE
    
    var title: String {
        switch self {
        case .LOCATION_CONDITION:
            return "LOCATION_CONDITION"
        case .INDOOR:
            return "INDOOR"
        case .PUBLIC_SPACE:
            return "PUBLIC_SPACE"
        }
    }
    
    var localizedTitle: String {
        switch self {
        case .LOCATION_CONDITION: return "입지여건"
        case .INDOOR: return "실내"
        case .PUBLIC_SPACE: return "공용공간"
        }
    }
}

extension CheckListCategoryType {
    static func from(raw: String) -> String {
        guard let item = self.allCases.first(where: { $0.title == raw })?.localizedTitle else {
            return ""
        }
        
        return item
    }
}
