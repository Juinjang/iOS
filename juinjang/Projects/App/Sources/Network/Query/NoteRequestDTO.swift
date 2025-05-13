//
//  NoteRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/12/25.
//

struct NoteRequestDTO: Encodable {
    let noteType: String
    let propertyType: String
    let priceType: String
    let keyword: String
}
