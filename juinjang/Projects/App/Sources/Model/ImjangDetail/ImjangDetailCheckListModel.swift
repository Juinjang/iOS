//
//  ImjangDetailCheckListModel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

struct ImjangDetailCheckListModel: Codable {
    let answerId: Int
    let questionId: Int
    let category: String
    let limjangId: Int
    let answer: String
    let answerType: String
}
