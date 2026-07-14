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
    private var isEnabled: Bool = true
    private let action: () -> Void

    // MARK: Init

    public init(
        _ title: String,
        style: AppButtonStyle = .main,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
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
        var copy = self
        copy.isEnabled = isEnabled
        return copy
    }
}
