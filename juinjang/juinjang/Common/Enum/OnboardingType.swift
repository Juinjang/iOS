//
//  OnboardingType.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import Foundation

enum OnboardingType: Int {
    case checklist
    case recordImjang
    case report
    
    var item1: OnboardingItem {
        switch self {
        case .checklist: OnboardingItem(title: "매물마다\n중요한 포인트는\n따로 있으니까",
                                        keyword: "중요한 포인트",
                                        jsonURLString: JsonURLString.checklist.urlString1)
        case .recordImjang: OnboardingItem(title: "중요한 대화,\n신경쓰지 않으면\n놓쳐버리니까",
                                           keyword: "놓쳐버리니까",
                                           jsonURLString: JsonURLString.recordImjang.urlString1)
        case .report: OnboardingItem(title: "모으는 것만큼\n분석하는 방법도\n중요하니까",
                                     keyword: "분석하는 방법",
                                     jsonURLString: JsonURLString.report.urlString1)
        }
    }
    
    var item2: OnboardingItem {
        switch self {
        case .checklist: OnboardingItem(title: "주인장\n맞춤 체크리스트로\n현명하게",
                                        keyword: "맞춤 체크리스트",
                                        jsonURLString: JsonURLString.checklist.urlString2)
        case .recordImjang: OnboardingItem(title: "주인장\n매물별 음성 녹음으로\n꼼꼼하게",
                                           keyword: "매물별 음성 녹음",
                                           jsonURLString: JsonURLString.recordImjang.urlString2)
        case .report: OnboardingItem(title: "리포트로\n분석과 비교까지\n주인장이 도와드릴게요!",
                                     keyword: "분석과 비교",
                                     jsonURLString: JsonURLString.report.urlString2)
        }
    }
}

enum JsonURLString {
    case checklist
    case recordImjang
    case report
    
    var urlString1: String {
        switch self {
        case .checklist: "checklist1"
        case .recordImjang: "recordImjang1"
        case .report: "report1"
        }
    }
    
    var urlString2: String {
        switch self {
        case .checklist: "checklist2"
        case .recordImjang: "recordImjang2"
        case .report: "report2"
        }
    }
}

