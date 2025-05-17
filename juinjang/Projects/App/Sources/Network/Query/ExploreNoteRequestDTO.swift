//
//  ExploreNoteRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

struct ExploreNoteRequestDTO: Encodable {
    let code: [String]
    let page: String
    let size: String
    let sort: String
    let propertyType: String
    let priceType: String
    let keyword: String
}
