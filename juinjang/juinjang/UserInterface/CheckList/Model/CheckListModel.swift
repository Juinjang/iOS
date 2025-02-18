//
//  CheckListModel.swift
//  juinjang
//
//  Created by 임수진 on 3/24/24.
//

import Foundation
import UIKit
import RealmSwift

struct CheckListCategory {
    let category: String
    let checkListitem: [CheckListItem]
    var isExpanded: Bool = false
    
    init(category: String, checkListitem: [CheckListItem], isExpanded: Bool) {
        self.category = category
        self.checkListitem = checkListitem
        self.isExpanded = isExpanded
    }
}

class CheckListItem: Object {
    @Persisted(primaryKey: true) var questionId: Int
    @Persisted var category: String
    @Persisted var question: String
    @Persisted var answerType: Int
    @Persisted var version: Int
    @Persisted var options: List<Option> // 선택형 질문인 경우 옵션 가짐
    
    convenience init(questionId: Int, category: String, question: String, answerType: Int, version: Int) {
        self.init()
        self.questionId = questionId
        self.category = category
        self.question = question
        self.answerType = answerType
        self.version = version
    }
}

class Option: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var option: String
    @Persisted var image: Data
    @Persisted(originProperty: "options") var checkListItem: LinkingObjects<CheckListItem>
    
    convenience init(option: String, image: Data? = nil) {
        self.init()
        self.option = option
        if let imageData = image {
            self.image = imageData
        }
    }
}

func addOptionData() {
    for item in items {
        if item.questionId == 4 {
            item.options.append(objectsIn: options1)
        }
    }
    
    for item in items {
        if item.questionId == 13 {
            item.options.append(objectsIn: options2)
        }
    }
    
    for item in items {
        if item.questionId == 14 {
            item.options.append(objectsIn: options3)
        }
    }
    
    for item in items {
        if item.questionId == 30 {
            item.options.append(objectsIn: options4)
        }
    }
    
    for item in items {
        if item.questionId == 33 {
            item.options.append(objectsIn: options5)
        }
    }
    
    for item in oneRoomItems {
        if item.questionId == 61 {
            item.options.append(objectsIn: options6)
        }
    }
    
    for item in oneRoomItems {
        if item.questionId == 62 {
            item.options.append(objectsIn: options1)
        }
    }
    
    for item in oneRoomItems {
        if item.questionId == 89 {
            item.options.append(objectsIn: options7)
        }
    }
}

// 각 질문에 해당하는 옵션 추가
var questionOptions: [Int: [Option]] = [:]

func mappingOption() {
    questionOptions[4] = options1
    questionOptions[13] = options2
    questionOptions[14] = options3
    questionOptions[30] = options4
    questionOptions[33] = options5
    questionOptions[61] = options6
    questionOptions[62] = options1
    questionOptions[89] = options7
}

// answerType - 0: 점수형 1: 선택형 2: 입력형 3: 달력
// version - 0: 임장용 1: 원룸용
var items: [CheckListItem] = [
    CheckListItem(questionId: 1, category: "기한", question: "입주 가능 날짜는 어떻게 되나요?", answerType: 3, version: 0),
    CheckListItem(questionId: 2, category: "기한", question: "잔금은 언제까지 치뤄야 하나요?", answerType: 3, version: 0),
    CheckListItem(questionId: 3, category: "입지여건", question: "찾고 계신 매물이 역세권인가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 4, category: "입지여건", question: "역세권이라면 지하철 노선도를 선택해 주세요.", answerType: 1, version: 0),
    CheckListItem(questionId: 5, category: "입지여건", question: "버스 주요노선이 지역중심부에 접근이 용이한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 6, category: "입지여건", question: "공립 어린이집 혹은 유치원이 충분히 가까운가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 7, category: "입지여건", question: "초등학교가 반경 5분~10분 이내에 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 8, category: "입지여건", question: "중학교가 반경 3km 내에 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 9, category: "입지여건", question: "응급상황 발생 시 찾아갈 의료시설이 갖춰져 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 10, category: "입지여건", question: "대형마트, 시장이 도보로 이용 가능한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 11, category: "입지여건", question: "여러 브랜드의 편의점이 근거리에 분포해있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 12, category: "입지여건", question: "입주자가 사용하는 은행이 근거리에 분포해있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 13, category: "입지여건", question: "강/공원/아파트 단지/건물 뷰를 골라주세요.", answerType: 1, version: 0),
    CheckListItem(questionId: 14, category: "입지여건", question: "동향/서향/남향/북향", answerType: 1, version: 0),
    CheckListItem(questionId: 15, category: "입지여건", question: "창문이 적절한 위치와 적절한 갯수를 갖추고 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 16, category: "입지여건", question: "빛이 잘 들어오나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 17, category: "입지여건", question: "근처에 술집, 노래방 등의 유흥시설이 가까운가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 18, category: "입지여건", question: "주변에 변전소, 고압선, 레미콘 공장 등이 가까운가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 19, category: "입지여건", question: "단지 내 위험을 대비한 안전장치가 구비되어 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 20, category: "입지여건", question: "건물의 건축년도를 입력해 주세요.", answerType: 2, version: 0),
    CheckListItem(questionId: 21, category: "입지여건", question: "찾고 계신 매물의 노후 정도가 괜찮은 편인가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 22, category: "공용공간", question: "주차공간이 세대 당 몇 대인가요?", answerType: 2, version: 0),
    CheckListItem(questionId: 23, category: "공용공간", question: "단지 내 놀이터가 잘 갖춰져 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 24, category: "공용공간", question: "단지 내 cctv가 설치된 놀이터가 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 25, category: "공용공간", question: "단지 내 헬스장이 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 26, category: "공용공간", question: "단지 내 노인정이 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 27, category: "공용공간", question: "출퇴근 시 엘리베이터 사용이 여유롭나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 28, category: "공용공간", question: "단지 내 택배를 안전하게 받을 수 있는 공간이 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 29, category: "공용공간", question: "단지 내 유모차 이동이 자유롭나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 30, category: "실내", question: "시스템 에어컨/설치형 에어컨/기타", answerType: 1, version: 0),
    CheckListItem(questionId: 31, category: "실내", question: "냉난방 시스템이 장 작동하나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 32, category: "실내", question: "창문은 이중창인가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 33, category: "실내", question: "복도형 구조/거실중앙형 구조/기타", answerType: 1, version: 0),
    CheckListItem(questionId: 34, category: "실내", question: "베란다 확장을 했나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 35, category: "실내", question: "현관 앞 공용공간이 충분한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 36, category: "실내", question: "현관에 중간문을 설치할 수 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 37, category: "실내", question: "신발장 넒이는 적절한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 38, category: "실내", question: "현관에 짐을 보관할 수 있는 창고가 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 39, category: "실내", question: "거실 바닥 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 40, category: "실내", question: "거실 벽면 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 41, category: "실내", question: "거실 베란다 창호와 방충망 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 42, category: "실내", question: "주방 바닥 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 43, category: "실내", question: "주방 벽면 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 44, category: "실내", question: "주방 통기성이 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 45, category: "실내", question: "주방 옆 펜트리가 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 46, category: "실내", question: "주방 수압은 괜찮은 편인가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 47, category: "실내", question: "방의 크기는 적당한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 48, category: "실내", question: "방의 갯수는 몇 개인가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 49, category: "실내", question: "방의 바닥 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 50, category: "실내", question: "방의 벽면 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 51, category: "실내", question: "방 안에 붙박이장이 설치되어 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 52, category: "실내", question: "화장실의 바닥 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 53, category: "실내", question: "화장실의 벽면 마감 상태가 양호한가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 54, category: "실내", question: "화장실 수는 적당한 편인가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 55, category: "실내", question: "화장실 환풍기가 정상적으로 작동하나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 56, category: "실내", question: "화장실 수압의 상태는 어떤가요?", answerType: 0, version: 0),
    CheckListItem(questionId: 57, category: "실내", question: "욕조/샤워부스가 따로 마련되어 있나요?", answerType: 0, version: 0),
    CheckListItem(questionId: 58, category: "실내", question: "소방시설이 잘 갖춰져 있나요?", answerType: 0, version: 0)
]

var options1: [Option] = [
    Option(option: "선택안함", image: nil),
    Option(option: "1호선", image: UIImage(named: "line1")?.pngData()),                  // 1호선
    Option(option: "2호선", image: UIImage(named: "line2")?.pngData()),                  // 2호선
    Option(option: "3호선", image: UIImage(named: "line3")?.pngData()),                  // 3호선
    Option(option: "4호선", image: UIImage(named: "line4")?.pngData()),                  // 4호선
    Option(option: "5호선", image: UIImage(named: "line5")?.pngData()),                  // 5호선
    Option(option: "6호선", image: UIImage(named: "line6")?.pngData()),                  // 6호선
    Option(option: "7호선", image: UIImage(named: "line7")?.pngData()),                  // 7호선
    Option(option: "8호선", image: UIImage(named: "line8")?.pngData()),                  // 8호선
    Option(option: "9호선", image: UIImage(named: "line9")?.pngData()),                  // 9호선
    Option(option: "수인분당", image: UIImage(named: "SuinBundangLine")?.pngData()),      // 수인분당선
    Option(option: "경의중앙", image: UIImage(named: "GyeonguiJungangLine")?.pngData()),  // 경의중앙선
    Option(option: "신분당", image: UIImage(named: "ShinbundangLine")?.pngData()),       // 신분당선
    Option(option: "공항철도", image: UIImage(named: "AirportRailroadLine")?.pngData()),  // 공항철도선
    Option(option: "경춘선", image: UIImage(named: "GyeongchunLine")?.pngData()),        // 경춘선
]

var options2: [Option] = [
    Option(option: "선택안함"),
    Option(option: "강"),
    Option(option: "공원"),
    Option(option: "아파트 단지")
]

var options3: [Option] = [
    Option(option: "선택안함"),
    Option(option: "동향"),
    Option(option: "서향"),
    Option(option: "남향"),
    Option(option: "북향")
]

var options4: [Option] = [
    Option(option: "선택안함"),
    Option(option: "시스템 에어컨"),
    Option(option: "설치형 에어컨"),
    Option(option: "기타")
]

var options5: [Option] = [
    Option(option: "선택안함"),
    Option(option: "복도형 구조"),
    Option(option: "거실중앙형 구조"),
    Option(option: "기타")
]

var oneRoomItems: [CheckListItem] = [
    CheckListItem(questionId: 59, category: "기한", question: "입주 가능 날짜는 어떻게 되나요?", answerType: 3, version: 1),
    CheckListItem(questionId: 60, category: "기한", question: "잔금은 언제까지 치뤄야 하나요?", answerType: 3, version: 1),
    CheckListItem(questionId: 61, category: "입지여건", question: "여성전용/남성전용/혼용", answerType: 1, version: 1),
    CheckListItem(questionId: 62, category: "입지여건", question: "역세권이라면 지하철 노선도를 선택해 주세요.", answerType: 1, version: 1),
    CheckListItem(questionId: 63, category: "입지여건", question: "역으로 도보 5분 이내 접근이 가능한가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 64, category: "입지여건", question: "버스 주요 노선이 서울 중심부 접근이 용이한가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 65, category: "입지여건", question: "직장 혹은 학교에 가는 데 무리가 없나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 66, category: "입지여건", question: "주변 소음으로부터 차단되는 정도를 입력해주세요.", answerType: 0, version: 1),
    CheckListItem(questionId: 67, category: "입지여건", question: "편의점, 은행과 같은 시설이 밀집해 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 68, category: "입지여건", question: "집 가는 길이 언덕에 위치해 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 69, category: "입지여건", question: "집 가는 길에 cctv나 가로등이 충분한가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 70, category: "공용공간", question: "주차공간이 세대 당 몇 대인가요?", answerType: 2, version: 1),
    CheckListItem(questionId: 71, category: "공용공간", question: "공동 현관 비밀번호가 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 72, category: "공용공간", question: "현관문 이중 잠금장치가 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 73, category: "공용공간", question: "출입구와 계단, 엘리베이터, 복도에 cctv가 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 74, category: "공용공간", question: "관리자분이 상주하고 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 75, category: "공용공간", question: "분리수거 환경이 잘 조성되어 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 76, category: "실내", question: "수압의 상태는 어떤가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 77, category: "실내", question: "온수는 잘 나오는 편인가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 78, category: "실내", question: "배수구는 잘 내려가나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 79, category: "실내", question: "햇빛이 잘 들어오나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 80, category: "실내", question: "방충망 상태가 양호한가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 81, category: "실내", question: "환기하는 데 문제가 없나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 82, category: "실내", question: "옆 건물로부터 사생활이 지켜지나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 83, category: "실내", question: "화장실 내부에 창문이 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 84, category: "실내", question: "화장실 배수구 냄새가 올라오는 편인가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 85, category: "실내", question: "화장실 샤워 공간이 충분한가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 86, category: "실내", question: "화장실 곰팡이 흔적이 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 87, category: "실내", question: "기본옵션이 충분한가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 88, category: "실내", question: "에어컨, 냉장고 등이 온전히 작동하나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 89, category: "실내", question: "화구의 종류는 무엇인가요?", answerType: 1, version: 1),
    CheckListItem(questionId: 90, category: "실내", question: "옵션 필요없다면 치워줄 수 있다는 답변을 받았나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 91, category: "실내", question: "수납공간이 충분한가요?", answerType: 0, version: 1),
    CheckListItem(questionId: 92, category: "실내", question: "벽지에 곰팡이 핀 흔적이 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 93, category: "실내", question: "콘센트가 적절한 위치에 배치되어 있나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 94, category: "실내", question: "인터폰 영상이 지원되나요?", answerType: 0, version: 1),
    CheckListItem(questionId: 95, category: "실내", question: "방음은 잘 되나요?", answerType: 0, version: 1),
]

var options6: [Option] = [
    Option(option: "선택안함"),
    Option(option: "여성전용"),
    Option(option: "남성전용"),
    Option(option: "혼용")
]

var options7: [Option] = [
    Option(option: "선택안함"),
    Option(option: "인덕션"),
    Option(option: "하이라이트"),
    Option(option: "가스"),
    Option(option: "기타")
]

