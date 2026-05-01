import SwiftUI

// MARK: - DSPolicyVersionSelector
/// 약관/정책 화면 하단의 버전 드롭다운.
/// - 닫힌 상태: 단일 행 (현재 버전 라벨 + chevron down)
/// - 열린 상태: 위쪽으로 펼쳐서 다른 버전 행이 보이고 + 현재 버전 행이 마지막에 chevron up과 남음
/// - 단일 버전이면 호출부에서 셀렉터 자체를 숨길 것 (`versions.count > 1` 분기).
///
/// **표시 방식**: 셀렉터 자체는 자기 영역만 그리기 때문에,
/// 호출부가 `ZStack` 등으로 위에 오버레이로 띄워야 expanded 시 본문을 밀지 않음.

public struct DSPolicyVersionSelector: View {
    public struct VersionItem: Identifiable, Equatable {
        public let id: String
        public let label: String

        public init(id: String, label: String) {
            self.id = id
            self.label = label
        }
    }

    private let versions: [VersionItem]
    @Binding private var selectedID: String
    @Binding private var isExpanded: Bool

    public init(
        versions: [VersionItem],
        selectedID: Binding<String>,
        isExpanded: Binding<Bool>
    ) {
        self.versions = versions
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
                    // 닫힘: 위쪽(^), 열림: 아래쪽(v)
                    // expandDown은 기본 v 방향이므로 닫힌 상태에서 180° 회전 → ^
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
            }
            .padding(.horizontal, 16)
            .frame(height: 63)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - 펼쳐진 상태에서 위로 보이는 다른 버전들

    @ViewBuilder
    private var expandedList: some View {
        VStack(spacing: 0) {
            ForEach(otherVersions) { version in
                Button {
                    selectedID = version.id
                    isExpanded = false
                } label: {
                    HStack {
                        DSText(version.label)
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
        versions.first(where: { $0.id == selectedID })?.label
            ?? versions.first?.label
            ?? ""
    }

    private var otherVersions: [VersionItem] {
        versions.filter { $0.id != selectedID }
    }
}

// MARK: - Previews

#Preview("Two versions, collapsed") {
    StateWrapper(initialID: "1.1.0", expanded: false)
        .padding(24)
}

#Preview("Two versions, expanded") {
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
        DSPolicyVersionSelector(
            versions: [
                .init(id: "1.1.0", label: "이용약관 버전 1.1.0 (시행일 2025.01.12)"),
                .init(id: "1.0.0", label: "이용약관 버전 1.0.0 (시행일 2024.09.11)")
            ],
            selectedID: $selectedID,
            isExpanded: $expanded
        )
    }
}
