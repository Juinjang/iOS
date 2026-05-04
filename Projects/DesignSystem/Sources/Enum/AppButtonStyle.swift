//
//  AppButtonStyle.swift
//  DesignSystem
//
//  Created by 조유진 on 5/4/26.
//

import SwiftUI

public enum AppButtonStyle {
    case main
    case gray
    
    var backgroundColor: Color {
        switch self {
        case .main: return .main
        case .gray: return .gray500
        }
    }
    
    var disabledColor: Color {
        return .null
    }
}
