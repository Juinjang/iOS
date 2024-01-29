//
//  ChecklistManager.swift
//  juinjang
//
//  Created by 임수진 on 1/25/24.
//

import Foundation

class ChecklistManager {
    var categories: [Category]

    init(categories: [Category]) {
        self.categories = categories
    }

    // MARK: - Update methods for specific item types

    func setSelectedDate(_ date: Date?, forItemAtIndex index: Int, inCategory categoryIndex: Int) {
        // 해당 인덱스의 날짜 항목에 대한 처리
        guard let category = categories[safe: categoryIndex], index < category.items.count else {
            return
        }

        if var item = category.items[index] as? CalendarItem {
            item.inputDate = date
            categories[categoryIndex].items[index] = item
        }
    }

    func setScore(_ score: String?, forItemAtIndex index: Int, inCategory categoryIndex: Int) {
        // 해당 인덱스의 점수 항목에 대한 처리
        guard let category = categories[safe: categoryIndex], index < category.items.count else {
            return
        }

        if var item = category.items[index] as? ScoreItem {
            item.score = score
            categories[categoryIndex].items[index] = item
        }
    }

    func setInputAnswer(_ answer: String?, forItemAtIndex index: Int, inCategory categoryIndex: Int) {
        // 해당 인덱스의 입력 답변 항목에 대한 처리
        guard let category = categories[safe: categoryIndex], index < category.items.count else {
            return
        }

        if var item = category.items[index] as? InputItem {
            item.inputAnswer = answer
            categories[categoryIndex].items[index] = item
        }
    }

    func setSelectAnswer(_ answer: String?, forItemAtIndex index: Int, inCategory categoryIndex: Int) {
        // 해당 인덱스의 선택 답변 항목에 대한 처리
        guard let category = categories[safe: categoryIndex], index < category.items.count else {
            return
        }

        if var item = category.items[index] as? SelectionItem {
            item.selectAnswer = answer
            categories[categoryIndex].items[index] = item
        }
    }
}

// Safe indexing extension
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

