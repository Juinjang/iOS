//
//  AnswerModel.swift
//  juinjang
//
//  Created by 임수진 on 5/12/24.
//

import Foundation

struct NoteCheckListQuestionAnswer: Codable {
    var imjangId: Int
    var questionId: Int
    var answer: String
    var isSelected: Bool
}

