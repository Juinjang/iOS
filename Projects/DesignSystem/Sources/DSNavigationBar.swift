import SwiftUI

// MARK: - DSNavigationBarStyle

public enum DSNavigationBarStyle {
    case `default`
    case search
    case center
}

// MARK: - DSNavigationBar
/// 커스텀 네비게이션 바 컴포넌트
///
/// 사용법:
/// ```
/// // 기본
/// DSNavigationBar()
///     .title("홈")
///     .leftItems([.pop])
///     .rightItems([.search, .setting])
///     .onAction { action in ... }
///
/// // 검색
/// DSNavigationBar(style: .search, searchText: $searchText)
///     .leftItems([.pop])
///     .placeholder("검색어를 입력해주세요")
///     .onAction { action in ... }
///
/// // 중앙 커스텀 뷰
/// DSNavigationBar(style: .center) {
///     SegmentedControl()
/// }
/// .leftItems([.pop])
/// .onAction { action in ... }
/// ```

public struct DSNavigationBar<CenterContent: View>: View {
    private let barStyle: DSNavigationBarStyle
    private let centerContent: CenterContent?
    private var titleText: String = ""
    private var titleColor: Color = .gray600
    private var leftButtons: [DSNavigationButton] = []
    private var rightButtons: [DSNavigationButton] = []
    private var actionHandler: ((DSNavigationAction) -> Void)?
    private var searchPlaceholder: String = ""
    @Binding private var searchText: String

    // MARK: - Default Style

    public init(
        style: DSNavigationBarStyle = .default
    ) where CenterContent == EmptyView {
        self.barStyle = style
        self.centerContent = nil
        self._searchText = .constant("")
    }

    // MARK: - Search Style

    public init(
        style: DSNavigationBarStyle = .search,
        searchText: Binding<String>
    ) where CenterContent == EmptyView {
        self.barStyle = style
        self.centerContent = nil
        self._searchText = searchText
    }

    // MARK: - Center Style

    public init(
        style: DSNavigationBarStyle = .center,
        @ViewBuilder centerContent: () -> CenterContent
    ) {
        self.barStyle = style
        self.centerContent = centerContent()
        self._searchText = .constant("")
    }

    public var body: some View {
        HStack(spacing: 0) {
            leftItemsView
                .padding(.leading, 24)

            Spacer()

            centerView

            Spacer()

            rightItemsView
                .padding(.trailing, 24)
        }
        .frame(height: 44)
    }

    // MARK: - Center View

    @ViewBuilder
    private var centerView: some View {
        switch barStyle {
        case .default:
            DSText(titleText)
                .style(.title)
                .textColor(titleColor)
                .textAlignment(.center)

        case .search:
            searchBarView

        case .center:
            if let centerContent {
                centerContent
            }
        }
    }

    // MARK: - Search Bar

    private var searchBarView: some View {
        HStack(spacing: 0) {
            TextField(searchPlaceholder, text: $searchText)
                .font(DSFontStyle.body2.font)
                .onSubmit {
                    actionHandler?(.searchSubmit(keyword: searchText))
                }
                .padding(.leading, 16)

            Button {
                if searchText.isEmpty {
                    actionHandler?(.searchButtonTap)
                } else {
                    searchText = ""
                    actionHandler?(.searchActive(isActive: false))
                }
            } label: {
                Image(searchText.isEmpty ? "search" : "close", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.gray400)
            }
            .padding(.trailing, 16)
        }
        .frame(height: 40)
        .background(Color.gray200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onChange(of: searchText) { _, newValue in
            actionHandler?(.searchActive(isActive: !newValue.isEmpty))
        }
    }

    // MARK: - Left/Right Items

    private var leftItemsView: some View {
        HStack(spacing: 16) {
            ForEach(Array(leftButtons.enumerated()), id: \.offset) { _, button in
                navigationButtonView(button)
            }
        }
    }

    private var rightItemsView: some View {
        HStack(spacing: 16) {
            ForEach(Array(rightButtons.enumerated()), id: \.offset) { _, button in
                navigationButtonView(button)
            }
        }
    }

    @ViewBuilder
    private func navigationButtonView(_ button: DSNavigationButton) -> some View {
        Button {
            actionHandler?(buttonAction(button))
        } label: {
            switch button {
            case let .text(title):
                DSText(title)
                    .style(.body2)
                    .textColor(.gray400)
            default:
                if let imageName = button.imageName {
                    Image(imageName, bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: button.buttonSize, height: button.buttonSize)
                        .foregroundStyle(button.tintColor)
                }
            }
        }
    }

    private func buttonAction(_ button: DSNavigationButton) -> DSNavigationAction {
        switch button {
        case .pop: return .popButtonTap
        case .search: return .searchButtonTap
        case .setting: return .settingButtonTap
        case .record: return .recordButtonTap
        case .add: return .addButtonTap
        case .close: return .closeButtonTap
        case .trash: return .trashButtonTap
        case .report: return .reportButtonTap
        case .startRecord: return .startRecordButtonTap
        case .text: return .textButtonTap
        }
    }
}

// MARK: - Chaining Modifiers

public extension DSNavigationBar {
    func title(_ text: String) -> DSNavigationBar {
        var copy = self
        copy.titleText = text
        return copy
    }

    func titleColor(_ color: Color) -> DSNavigationBar {
        var copy = self
        copy.titleColor = color
        return copy
    }

    func leftItems(_ items: [DSNavigationButton]) -> DSNavigationBar {
        var copy = self
        copy.leftButtons = items
        return copy
    }

    func rightItems(_ items: [DSNavigationButton]) -> DSNavigationBar {
        var copy = self
        copy.rightButtons = items
        return copy
    }

    func placeholder(_ text: String) -> DSNavigationBar {
        var copy = self
        copy.searchPlaceholder = text
        return copy
    }

    func onAction(_ handler: @escaping (DSNavigationAction) -> Void) -> DSNavigationBar {
        var copy = self
        copy.actionHandler = handler
        return copy
    }
}
