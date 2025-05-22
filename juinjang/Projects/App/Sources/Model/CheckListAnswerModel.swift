//
//  CheckListAnswerModel.swift
//  juinjang
//
//  Created by KimDongWoo on 5/18/25.
//

struct CheckListAnswerModel: Codable {
    let answerId: Int
    let questionId: Int
    let category: String
    let limjangId: Int
    let answer: String
    let answerType: String
}
