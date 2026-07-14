//
//  PretendardWeight.swift
//  DesignSystem
//
//  Created by 조유진 on 5/4/26.
//

import SwiftUI

public enum PretendardWeight {
    case thin
    case extraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black

    var swiftUIFont: (CGFloat) -> Font {
        switch self {
        case .thin:       { DesignSystemFontFamily.Pretendard.thin.swiftUIFont(size: $0) }
        case .extraLight: { DesignSystemFontFamily.Pretendard.extraLight.swiftUIFont(size: $0) }
        case .light:      { DesignSystemFontFamily.Pretendard.light.swiftUIFont(size: $0) }
        case .regular:    { DesignSystemFontFamily.Pretendard.regular.swiftUIFont(size: $0) }
        case .medium:     { DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: $0) }
        case .semiBold:   { DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: $0) }
        case .bold:       { DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: $0) }
        case .extraBold:  { DesignSystemFontFamily.Pretendard.extraBold.swiftUIFont(size: $0) }
        case .black:      { DesignSystemFontFamily.Pretendard.black.swiftUIFont(size: $0) }
        }
    }
}
