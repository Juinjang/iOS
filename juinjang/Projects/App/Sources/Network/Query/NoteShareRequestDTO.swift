//
//  NoteShareRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/13/25.
//

struct NoteShareRequestDTO: Encodable {
    let buildingName: String
    let isImageShared: Bool
    let year: Int
    let month: Int
    let period: String
    let review: String
}
