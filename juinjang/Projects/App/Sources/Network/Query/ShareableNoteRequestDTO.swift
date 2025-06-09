//
//  SharedNoteRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 6/7/25.
//

struct ShareableNoteRequestDTO: Encodable {
    let sort: String?              // 예: "POPULAR" 또는 "LATEST"
    let propertyType: String?      // 예: "APARTMENT", "VILLA", "OFFICE_TEL", "DETACHED_HOUSE"
    let priceType: String?         // 예: "SALE", "PULL_RENT", "MONTHLY_RENT", "MARKET_PRICE"
    let keyword: String?           // 예: "검색어"
    let pageable: Pageable         // 필수

    struct Pageable: Encodable {
        let page: Int              // 예: 0
        let size: Int              // 예: 20
        let sort: [String]         // 예: ["createdAt,desc"]
    }
}
