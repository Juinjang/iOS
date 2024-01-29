//
//  CheckListItem.swift
//  juinjang
//
//  Created by 임수진 on 1/19/24.
//

import Foundation
import UIKit

struct Category {
    var image: UIImage
    var name: String
    var items: [Item] // 공통 프로토콜
    var isExpanded: Bool

    init(image: UIImage, name: String, items: [Item]) {
        self.image = image
        self.name = name
        self.items = items
        self.isExpanded = false
    }
}

protocol Item {
    var content: String { get }
    var isSelected: Bool { get set }
}

struct CalendarItem: Item {
    var content: String
    var inputDate: Date?
    var isSelected: Bool
    
    init(content: String) {
        self.content = content
        self.isSelected = false
    }
}

struct ScoreItem: Item {
    var content: String
    var score: String?
    var isSelected: Bool
    
    init(content: String) {
        self.content = content
        self.isSelected = false
    }
}

struct InputItem: Item {
    var content: String
    var inputAnswer: String?
    var isSelected: Bool
    
    init(content: String) {
        self.content = content
        self.isSelected = false
    }
}

struct SelectionItem: Item {
    var content: String
    var options: [String]
    var selectAnswer: String?
    var isSelected: Bool
    
    init(content: String, options: [String]) {
        self.content = content
        self.options = options
        self.isSelected = false
    }
}

protocol DataUpdateDelegate: AnyObject {
    func getItem(at indexPath: IndexPath) -> Item
    func updateItem(item: Item, at indexPath: IndexPath)
}
