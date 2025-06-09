//
//  ShareableNoteRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 6/11/25.
//

struct ShareableNoteRequestDTO: Codable {
    let sort: String?
    let propertyType: String?
    let priceType: String?
    let keyword: String?
    let pageable: Pageable
    
    struct Pageable: Codable {
        let page: Int
        let size: Int
        let sort: [String]
    }
}
