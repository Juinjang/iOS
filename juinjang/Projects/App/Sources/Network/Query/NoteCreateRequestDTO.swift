//
//  AddNoteRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

struct AddNoteRequestDTO: Encodable {
    let purposeType: String
    let propertyType: String
    let priceType: String
    let price: String
    let monthlyRent: String?
}
