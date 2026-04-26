import SwiftUI

// MARK: - DSSectionDivider
/// 섹션 사이를 구분하는 가로 컬러 바 (단독 사용)
///
/// 사용법:
/// ```
/// VStack(spacing: 0) {
///     menuRow("연필상점")
///     DSSectionDivider()
///     menuRow("약관 및 정책")
/// }
/// ```

public struct DSSectionDivider: View {
    private let height: CGFloat
    private let color: Color

    public init(
        height: CGFloat = 4,
        color: Color = .gray100
    ) {
        self.height = height
        self.color = color
    }

    public var body: some View {
        color.frame(height: height)
    }
}

// MARK: - View.sectionDivider modifier
/// 뷰의 위/아래에 sectionDivider를 붙이는 모디파이어. 체이닝으로 height/color 커스터마이즈 가능.
///
/// 사용법:
/// ```
/// pencilShopRow.sectionDivider(.top)
/// pencilShopRow.sectionDivider([.top, .bottom])
/// pencilShopRow.sectionDivider(.top).height(8).color(.stroke)
/// ```

public extension View {
    func sectionDivider(_ edges: Edge.Set = .bottom) -> DSSectionDividerWrapper<Self> {
        DSSectionDividerWrapper(content: self, edges: edges)
    }
}

public struct DSSectionDividerWrapper<Content: View>: View {
    private let content: Content
    private var edges: Edge.Set
    private var height: CGFloat = 4
    private var color: Color = .gray100

    init(content: Content, edges: Edge.Set) {
        self.content = content
        self.edges = edges
    }

    public var body: some View {
        VStack(spacing: 0) {
            if edges.contains(.top) {
                color.frame(height: height)
            }

            content

            if edges.contains(.bottom) {
                color.frame(height: height)
            }
        }
    }

    public func height(_ value: CGFloat) -> Self {
        var copy = self
        copy.height = value
        return copy
    }

    public func color(_ value: Color) -> Self {
        var copy = self
        copy.color = value
        return copy
    }
}

// MARK: - Previews

private struct DSSectionDividerSampleRow: View {
    let title: String

    var body: some View {
        DSText(title)
            .style(.title)
            .textColor(.gray500)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
    }
}

#Preview("DSSectionDivider - Standalone") {
    VStack(spacing: 0) {
        DSSectionDividerSampleRow(title: "연필상점")
        DSSectionDivider()
        DSSectionDividerSampleRow(title: "약관 및 정책")
        DSSectionDividerSampleRow(title: "자주 묻는 질문")
        DSSectionDivider()
        DSSectionDividerSampleRow(title: "로그아웃")
    }
    .background(Color.mainWhite)
}

#Preview("sectionDivider - Modifier") {
    VStack(spacing: 0) {
        DSSectionDividerSampleRow(title: "프로필 영역")

        DSSectionDividerSampleRow(title: "연필상점")
            .sectionDivider(.top)

        DSSectionDividerSampleRow(title: "약관 및 정책")
            .sectionDivider(.top)

        DSSectionDividerSampleRow(title: "로그아웃")
            .sectionDivider(.top)
    }
    .background(Color.mainWhite)
}

#Preview("sectionDivider - Chaining height/color") {
    VStack(spacing: 0) {
        DSSectionDividerSampleRow(title: "default (4pt, gray100)")
            .sectionDivider(.top)

        DSSectionDividerSampleRow(title: "thicker (10pt)")
            .sectionDivider(.top)
            .height(10)

        DSSectionDividerSampleRow(title: "stroke 1pt")
            .sectionDivider(.top)
            .height(1)
            .color(.stroke)

        DSSectionDividerSampleRow(title: "both edges")
            .sectionDivider([.top, .bottom])
            .height(2)
            .color(.main)
    }
    .background(Color.mainWhite)
}
