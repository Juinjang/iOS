//
//  AppButton.swift
//  DesignSystem
//
//  Created by 조유진 on 5/4/26.
//

import SwiftUI

public struct AppButton: View {
    
    // MARK: Properties
    
    private let title: String
    private let style: AppButtonStyle
    private let isEnabled: Bool
    private let action: () -> Void
    
    // MARK: Init
    
    public init(
        _ title: String,
        style: AppButtonStyle = .main,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    // MARK: Body
    
    public var body: some View {
        Button {
            action()
        } label: {
            DSText(title)
                .style(.title)
                .textColor(.mainWhite)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(currentBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(!isEnabled)
    }
    
    // MARK: - Private
    
    private var currentBackgroundColor: Color {
        isEnabled ? style.backgroundColor : style.disabledColor
    }
}

public extension AppButton {
    func enabled(_ isEnabled: Bool) -> AppButton {
        AppButton(title, style: style, isEnabled: isEnabled, action: action)
    }
}
