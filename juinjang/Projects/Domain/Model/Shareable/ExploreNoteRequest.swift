//
//  ExploreNoteRequest.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

public struct ExploreNoteRequest {
    let code: [String]?
    var sort: String
    var propertyType: String
    var priceType: String
    var keyword: String?
    let page: Int
    let size: Int
}

