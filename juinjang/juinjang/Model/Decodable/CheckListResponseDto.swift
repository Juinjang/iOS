//
//  CheckListResponseDto.swift
//  juinjang
//
//  Created by 임수진 on 2/15/24.
//

struct CheckListResponseDto: Codable {
    let category: Int
    let questionDtos: [QuestionDto]
    var isExpanded: Bool?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(Int.self, forKey: .category)
        self.questionDtos = try container.decode([QuestionDto].self, forKey: .questionDtos)
        self.isExpanded = false
    }
}

struct QuestionDto: Codable {
    let questionId: Int
    let category: Int
    let subCategory: String
    let question: String
    let version: Int
    let answerType: Int // 0: 점수형 1: 선택형 2: 입력형 3: 달력
    let options: [OptionDto]
    let answer: String?
}

struct OptionDto: Codable {
    let indexNum: Int
    let questionId: Int
    let optionValue: String
}

extension CheckListResponseDto {
    func filterCategoryZero(isEditMode: Bool) -> CheckListResponseDto? {
        if isEditMode || category != 0 {
            return self
        }
        return nil
    }
}
