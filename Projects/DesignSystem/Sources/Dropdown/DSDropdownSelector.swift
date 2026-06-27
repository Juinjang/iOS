import SwiftUI

// MARK: - DSDropdownSelector
/// 위로 펼쳐지는 단일 선택 드롭다운.
/// - 닫힘: 현재 선택 항목 1행 + chevron
/// - 열림: 위로 다른 항목들이 펼쳐지고, 현재 항목 행은 chevron up과 함께 맨 아래 유지
/// - 항목이 1개뿐이면 호출부에서 셀렉터 자체를 숨길 것 (`items.count > 1` 분기).
///
/// 셀렉터는 자기 영역만 그리므로, expanded 시 본문을 밀지 않으려면 호출부가 `ZStack` 오버레이로 띄울 것.

public struct DSDropdownSelector: View {
    public struct Item: Identifiable, Equatable {
        public let id: String
        public let label: String

        public init(id: String, label: String) {
            self.id = id
            self.label = label
        }
    }

    private let items: [Item]
    @Binding private var selectedID: String
    @Binding private var isExpanded: Bool

    public init(
        items: [Item],
        selectedID: Binding<String>,
        isExpanded: Binding<Bool>
    ) {
        self.items = items
        self._selectedID = selectedID
        self._isExpanded = isExpanded
    }

    public var body: some View {
        VStack(spacing: 0) {
            if isExpanded {
                expandedList
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            currentRow
        }
        .background(Color.mainWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.stroke, lineWidth: 1)
        )
    }

    // MARK: - 현재 선택 행 (탭하면 토글)

    private var currentRow: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 0) {
                DSText(currentLabel)
                    .style(.title)
                    .textColor(.gray450)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image.expandDown
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(Color.gray450)
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
            }
            .padding(.horizontal, 16)
            .frame(height: 63)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - 펼쳐진 상태에서 위로 보이는 다른 항목들

    @ViewBuilder
    private var expandedList: some View {
        VStack(spacing: 0) {
            ForEach(otherItems) { item in
                Button {
                    selectedID = item.id
                    isExpanded = false
                } label: {
                    HStack {
                        DSText(item.label)
                            .style(.title)
                            .textColor(.gray450)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 63)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Divider()
                    .background(Color.stroke)
            }
        }
    }

    // MARK: - 헬퍼

    private var currentLabel: String {
        items.first(where: { $0.id == selectedID })?.label
            ?? items.first?.label
            ?? ""
    }

    private var otherItems: [Item] {
        items.filter { $0.id != selectedID }
    }
}

// MARK: - Previews

#Preview("Two items, collapsed") {
    StateWrapper(initialID: "1.1.0", expanded: false)
        .padding(24)
}

#Preview("Two items, expanded") {
    StateWrapper(initialID: "1.1.0", expanded: true)
        .padding(24)
}

private struct StateWrapper: View {
    @State var selectedID: String
    @State var expanded: Bool

    init(initialID: String, expanded: Bool) {
        self._selectedID = State(initialValue: initialID)
        self._expanded = State(initialValue: expanded)
    }

    var body: some View {
        DSDropdownSelector(
            items: [
                .init(id: "1.1.0", label: "이용약관 버전 1.1.0 (시행일 2025.01.12)"),
                .init(id: "1.0.0", label: "이용약관 버전 1.0.0 (시행일 2024.09.11)")
            ],
            selectedID: $selectedID,
            isExpanded: $expanded
        )
    }
}
