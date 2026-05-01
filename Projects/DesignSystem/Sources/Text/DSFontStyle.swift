import SwiftUI

// MARK: - DSFontStyle
/// 프로젝트 공통 폰트 스타일 정의
/// Pretendard 커스텀 폰트 기반
///
/// 매핑 표:
///   case        size  weight     사용 예
///   ─────────────────────────────────────
///   h1          24    bold
///   h2, h4(20)  20    bold/semi
///   h3          18    bold       강한 강조 헤더
///   bodyLarge   18    medium     큰 본문 / 알림 메시지
///   title, body 16    semi/med
///   body2       14    medium
///   regular     13    regular

public enum DSFontStyle: Sendable {
    case h1, h2, h3, h4
    case title, body, bodyLarge, body2
    case regular

    public var size: CGFloat {
        switch self {
        case .h1: return 24
        case .h2, .h4: return 20
        case .h3, .bodyLarge: return 18
        case .title, .body: return 16
        case .body2: return 14
        case .regular: return 13
        }
    }

    public var font: Font {
        pretendardFont.swiftUIFont(size: size)
    }

    public var lineHeight: CGFloat {
        size >= 18 ? size * 1.35 : size * 1.45
    }

    public var letterSpacing: CGFloat {
        size * -0.02
    }

    private var pretendardFont: DesignSystemFontConvertible {
        switch self {
        case .h1, .h2, .h3:
            return DesignSystemFontFamily.Pretendard.bold
        case .h4, .title:
            return DesignSystemFontFamily.Pretendard.semiBold
        case .body, .body2, .bodyLarge:
            return DesignSystemFontFamily.Pretendard.medium
        case .regular:
            return DesignSystemFontFamily.Pretendard.regular
        }
    }
}
