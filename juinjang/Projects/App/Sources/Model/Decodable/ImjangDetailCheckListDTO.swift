//
//  ImjangDetailCheckListDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/16/25.
//

struct ImjangDetailCheckListDTO: Codable {
    let checkListAnswers: [ImjangDetailCheckListModel]
    let review: String
    let totalRate: Double
}
