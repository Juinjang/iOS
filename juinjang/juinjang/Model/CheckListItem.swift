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

var categories: [Category] = [
    Category(image: UIImage(named: "deadline-item")!, name: "기한", items: [
            CalendarItem(content: "입주 가능 날짜는 어떻게 되나요?"),
            CalendarItem(content: "잔금은 언제까지 치뤄야 하나요?")
        ]),
    Category(image: UIImage(named: "location-conditions-item")!, name: "입지여건", items: [
        ScoreItem(content: "역세권인가요?"),
        SelectionItem(content: "지하철 노선도를 선택해 주세요.", options: ["선택안함", "1호선", "2호선", "3호선", "4호선", "5호선", "6호선", "7호선", "8호선", "9호선", "수인분당", "경의중앙", "신분당", "공항철도", "경춘선"]),
        ScoreItem(content: "버스 주요노선이 지역중심부에 접근이 용이한가요?"),
        ScoreItem(content: "공립 어린이집 혹은 유치원이 충분히 가까운가요?"),
        ScoreItem(content: "초등학교가 반경 5분~10분 이내에 있나요?"),
        ScoreItem(content: "중학교가 반경 3km내에 있나요?"),
        ScoreItem(content: "응급상황 발생 시 찾아갈 의료시설이 갖춰져 있나요?"),
        ScoreItem(content: "대형마트, 시장이 도보로 이용 가능한가요?"),
        ScoreItem(content: "여러 브랜드의 편의점이 근거리에 분포해있나요?"),
        ScoreItem(content: "입주자가 사용하는 은행이 근거리에 분포해있나요?"),
        SelectionItem(content: "건물뷰를 골라주세요.", options: ["선택안함", "강", "공원", "아파트 단지"]),
        SelectionItem(content: "동향/서향/남향/북향", options: ["선택안함", "동향", "서향", "남향", "북향"]),
        ScoreItem(content: "창문이 적절한 위치와 적절한 갯수를 갖추고 있나요?"),
        ScoreItem(content: "빛이 잘 들어오나요?"),
        ScoreItem(content: "근처에 술집, 노래방 등의 유흥시설이 가까운가요?"),
        ScoreItem(content: "주변에 변전소, 고압선, 레미콘 공장등이 가까운가요?"),
        ScoreItem(content: "단지 내 위험을 대비한 안전장치가 구비되어 있나요?"),
        ScoreItem(content: "찾고 계신 매물의 노후 정도가 괜찮은 편인가요?"),
        InputItem(content: "건축년도를 입력해 주세요.")
    ]),
    Category(image: UIImage(named: "public-space-item")!, name: "공용공간", items: [
        InputItem(content: "주차공간이 세대 당 몇 대인가요?"),
        ScoreItem(content: "단지 내 놀이터가 잘 갖춰져 있나요?"),
        ScoreItem(content: "단지 내 cctv가 설치된 놀이터가 있나요?"),
        ScoreItem(content: "단지 내 헬스장이 있나요?"),
        ScoreItem(content: "단지 내 노인정이 있나요?"),
        ScoreItem(content: "출퇴근 시 엘리베이터 사용이 여유롭나요?"),
        ScoreItem(content: "단지 내 택배를 안전하게 받을 수 있는 공간이 있나요?"),
        ScoreItem(content: "단지 내 유모차 이동이 자유롭나요?")
    ]),
    Category(image: UIImage(named: "indoor-item")!, name: "실내", items: [
        SelectionItem(content: "시스템 에어컨 / 설치형에어컨 / 기타", options: ["선택안함", "시스템 에어컨", "설치형에어컨", "기타"]),
        ScoreItem(content: "냉난방 시스템이 장 작동하나요?"),
        ScoreItem(content: "창문은 이중창인가요?"),
        ScoreItem(content: "복도형 구조 / 거실중앙형 구조 / 기타"),
        ScoreItem(content: "베란다 확장을 했나요?"),
        ScoreItem(content: "현관 앞 공용공간이 충분한가요?"),
        ScoreItem(content: "현관에 중간문을 설치할 수 있나요?"),
        ScoreItem(content: "신발장 넒이는 적절한가요?"),
        ScoreItem(content: "현관에 짐을 보관할 수 있는 창고가 있나요?"),
        ScoreItem(content: "거실 바닥 마감 상태가 양호한가요?"),
        ScoreItem(content: "거실 벽면 마감 상태가 양호한가요?"),
        ScoreItem(content: "거실 베란다 창호와 방충망 상태가 양호한가요?"),
        ScoreItem(content: "주방 바닥 마감 상태가 양호한가요?"),
        ScoreItem(content: "주방 벽면 마감 상태가 양호한가요?"),
        ScoreItem(content: "주방 통기성이 양호한가요?"),
        ScoreItem(content: "주방 옆 펜트리가 있나요?"),
        ScoreItem(content: "주방 싱크대 수압은 괜찮은 편인가요?"),
        ScoreItem(content: "방의 크기는 적당한가요?"),
        InputItem(content: "방의 갯수는 몇 개인가요?"),
        ScoreItem(content: "방의 바닥 마감 상태가 양호한가요?"),
        ScoreItem(content: "방의 벽면 마감 상태가 양호한가요?"),
        ScoreItem(content: "방 안에 붙방이장이 설치되어 있나요?"),
        ScoreItem(content: "화장실의 바닥 마감 상태가 양호한가요?"),
        ScoreItem(content: "화장실의 벽면 마감 상태가 양호한가요?"),
        ScoreItem(content: "화장실 수는 적당한 편인가요?"),
        ScoreItem(content: "환풍기가 정상적으로 작동하나요?"),
        ScoreItem(content: "화장실 세면대 수압의 상태는 어떤가요?"),
        ScoreItem(content: "욕조/샤워부스가 따로 마련되어 있나요?"),
        ScoreItem(content: "소방대피시설이 잘 갖춰져 있나요?")
    ]),
]
