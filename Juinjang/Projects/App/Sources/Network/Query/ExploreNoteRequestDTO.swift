//
//  ExploreNoteRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

struct ExploreNoteRequestDTO: Encodable {
    let code: [String]?
    var sort: String
    var propertyType: String
    var priceType: String
    var keyword: String?
    let page: Int
    let size: Int
    
    init(
        code: [String]? = nil,
        sort: String = "POPULAR",
        propertyType: String = "",
        priceType: String = "",
        keyword: String? = nil,
        page: Int,
        size: Int
    ) {
        self.code = code
        self.sort = sort
        self.propertyType = propertyType
        self.priceType = priceType
        self.keyword = keyword
        self.page = page
        self.size = size
    }
}

