//
//  Untitled.swift
//  juinjang
//
//  Created by 조유진 on 1/31/25.
//

enum AmpliEventName: String {
    // 온보딩 -> 회원가입
    case onboarding_start
    case onboarding_step_1
    case onboarding_step_2
    case onboarding_step_3
    case onboarding_complete
    
    case signup = "회원가입"
    
    case page_viewed = "page viewed"
    case button_clicked = "button clicked"
}


enum AmpliEventProp: String {
    // 메인 홈 화면 진입 -> 새 페이지 펼치기_step1
    case newPage
    case deal_object
    case deal_category
    case deal_price

    // 새 페이지 펼치기_step1 -> 새 페이지 펼치기_step 2
    case info_page_2
    case address_id
    case address_name
    
    // 새 페이지 펼치기_step2 -> 체크리스트 화면
    case next_button_clicked
    case checklist_page
    case floating_button
    case moving_date
    case pay_date
    case record_room
    case record_file
    case record_memo
}

enum AmpliEventPropValue: String {
    case investment = "부동산 투자"
    case direct_entry = "직접 입주"
    
    case apart = "아파트"
    case villa = "빌라"
    case officetel = "오피스텔"
    case detached_house = "단독 주택"
}
