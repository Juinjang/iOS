//
//  Filter.swift
//  juinjang
//
//  Created by 조유진 on 1/26/24.
//

import Foundation

public enum Filter: Int, CaseIterable {
    case update
    case star
    case created
    
    public var title: String {
        switch self {
        case .update: return "업데이트순"
        case .star: return "별점순"
        case .created: return "등록순"
        }
    }
    
    public var sortValue: String {
        switch self {
        case .update: return "UPDATED"
        case .star: return "STAR"
        case .created: return "CREATED"
        }
    }
}
