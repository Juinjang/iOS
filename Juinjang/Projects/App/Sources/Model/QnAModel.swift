//
//  QnAModel.swift
//  Juinjang
//
//  Created by 박도연 on 1/15/24.
//

import Foundation

struct Sections {
    let question: String
    var answer: String
    let highlight: String
    let iconName: String = "question"
    var isOpened: Bool = false
    static let sections: [Sections] = [
        Sections(question: "로고는 어떤 의미를 담고 있나요?", answer: "‘주인장’ 의 ‘ㅈ’을 돌려서 집 모양으로 만들어 봤어요. \n손으로 그린 듯한 선과 둥근 형태감을 통해 든든하고 친근한 주인장의 이미지를 전달하고자 했답니다.", highlight: "로고"),
        Sections(question: "체크리스트는 어떤 기준으로 나뉘나요?", answer: "임장노트>생성하기에서 사용자가 선택한 조건에 맞추어 체크리스트를 제공하고 있습니다.\n만일 부동산 투자가 목적이시면 일괄적으로 임장용 체크리스트를 제공하고 있고, 직접 입주>빌라 같은 경우에만 원룸용 체크리스트를 제공하고 있습니다.", highlight: "어떤 기준"),
        Sections(question: "왜 숫자로 기록해야 하나요?", answer: "답변의 주관성을 가장 객관적인 지표로서 나타낼 수 있는 것은 숫자라고 생각했습니다.\n구간별 평균점수와 리포트를 제공함으로써 사용자에게 한 눈에 매물을 파악할 수 있도록 돕고 있습니다.", highlight: "숫자로 기록"),
        Sections(question: "Speach to text의 정확도가 떨어져요.", answer: "개선될 여지는 있습니다. 추후 여러 단계별 유료 주인장 플랜을 준비하며 개선해보도록 하겠습니다.", highlight: "Speach to text"),
        Sections(question: "녹음 개수는 왜 제한하나요?", answer: "현재는 5개까지 지원하고 있지만, 추후 여러 단계별 유료 주인장 플랜을 준비하며 더욱 다양한 서비스를 지원하도록 하겠습니다.", highlight: "녹음 개수"),
        Sections(question: "직방, 다방 같은 어플과 연동은 안 되나요?", answer: "주인장 서비스는 현재 다른 어플과의 연동을 지원하고 있지 않습니다.", highlight: "어플과 연동"),
        Sections(question: "사용성 피드백은 어디로 하면 되나요?", answer: "사용성 평가는 앱스토어 혹은 juinjang1227@gmail.com으로 주시면 대단히 감사하겠습니다.", highlight: "사용성 피드백"),
    ]
}

