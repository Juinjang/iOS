//
//  ExploreNoteResponseDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

struct ExploreNoteResponseDTO: Codable {
    let totalResults: Int
    let notes: [ExploreNoteModel]
}
