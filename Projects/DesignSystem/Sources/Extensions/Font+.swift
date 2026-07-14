//
//  Font+.swift
//  DesignSystem
//
//  Created by 조유진 on 5/4/26.
//

import SwiftUI

public extension Font {
    /// 사용 예:
    /// ```swift
    /// Text("Hello")
    ///     .font(.pretendard(.regular, size: 16))
    /// ```
    static func pretendard(_ weight: PretendardWeight, size: CGFloat) -> Font {
        weight.swiftUIFont(size)
    }
}
