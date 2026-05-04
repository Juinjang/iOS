//
//  OnboardingPage.swift
//  Onboarding
//
//  Created by 조유진 on 4/20/26.
//

// MARK: - OnboardingPage

public enum OnboardingPage: Int, CaseIterable, Equatable, Sendable {
    case checklist = 0
    case recordImjang = 1
    case report = 2

    var introLottieName: String {
        switch self {
        case .checklist: 
            return "checklist1"
        case .recordImjang: 
            return "recordImjang1"
        case .report: 
            return "report1"
        }
    }

    var outroLottieName: String {
        switch self {
        case .checklist: 
            return "checklist2"
        case .recordImjang: 
            return "recordImjang2"
        case .report: 
            return "report2"
        }
    }

    var title1: String {
        switch self {
        case .checklist: 
            return "매물마다\n중요한 포인트는\n따로 있으니까"
        case .recordImjang: 
            return "중요한 대화,\n신경쓰지 않으면\n놓쳐버리니까"
        case .report: 
            return "모으는 것만큼\n분석하는 방법도\n중요하니까"
        }
    }
    
    var title1Highlight: [String] {
        switch self {
        case .checklist:
            return ["중요한 포인트"]
        case .recordImjang:
            return ["놓쳐버리니까"]
        case .report:
            return ["분석하는 방법"]
        }
    }

    var title2: String {
        switch self {
        case .checklist: return "주인장\n맞춤 체크리스트로\n현명하게"
        case .recordImjang: return "주인장\n매물별 음성 녹음으로\n꼼꼼하게"
        case .report: return "리포트로\n분석과 비교까지\n주인장이 도와드릴게요!"
        }
    }
    
    var title2Highlight: [String] {
        switch self {
        case .checklist:
            return ["맞춤 체크리스트"]
        case .recordImjang:
            return ["매물별 음성 녹음"]
        case .report:
            return ["리포트", "분석과 비교"]
        }
    }
}
