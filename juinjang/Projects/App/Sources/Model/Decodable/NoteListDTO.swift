//
//  NoteListDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/3/25.
//

struct NoteListDTO<T: Codable>: Codable {
    let notes: [T]
}
