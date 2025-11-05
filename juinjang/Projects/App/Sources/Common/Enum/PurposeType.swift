//
//  PurposeType.swift
//  juinjang
//
//  Created by 조유진 on 6/6/25.
//

enum PurposeType: String {
    case INVESTMENT
    case RESIDENTIAL_PURPOSE
    
    var title: String {
        return self.rawValue
    }
    
    var index: Int {
        switch self {
        case .INVESTMENT: 0
        case .RESIDENTIAL_PURPOSE: 1
        }
    }
}
