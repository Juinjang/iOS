//
//  ExploreNoteRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

struct ExploreNoteRequestDTO: Encodable {
    let code: [String]?
    let page: String
    let size: String
    let sort: String
    let propertyType: String?
    let priceType: String?
    let keyword: String?
    
    init(
        code: [String]? = nil,
        page: String = "1",
        size: String = "10",
        sort: String = "POPULAR",
        propertyType: String? = nil,
        priceType: String? = nil,
        keyword: String? = nil
    ) {
        self.code = code
        self.page = page
        self.size = size
        self.sort = sort
        self.propertyType = propertyType
        self.priceType = priceType
        self.keyword = keyword
    }
}
