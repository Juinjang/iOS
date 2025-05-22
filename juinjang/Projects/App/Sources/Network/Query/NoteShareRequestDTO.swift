//
//  NoteShareRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/13/25.
//

struct NoteShareRequestDTO: Encodable {
    let buildingName: String
    let isPhotoShared: Bool
    let year: Int
    let month: Int
    let period: Int
    let review: String
}
