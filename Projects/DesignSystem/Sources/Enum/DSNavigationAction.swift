//
//  DSNavigationAction.swift
//  DesignSystem
//
//  Created by 조유진 on 4/20/26.
//

// MARK: - DSNavigationAction
/// 네비게이션 바에서 발생하는 액션

public enum DSNavigationAction: Equatable {
    case popButtonTap
    case searchButtonTap
    case searchSubmit(keyword: String)
    case searchActive(isActive: Bool)
    case settingButtonTap
    case recordButtonTap
    case addButtonTap
    case closeButtonTap
    case textButtonTap
    case trashButtonTap
    case reportButtonTap
    case startRecordButtonTap
}
