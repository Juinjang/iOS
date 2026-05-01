import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

public struct TermsDetailView: View {
    @Bindable var store: StoreOf<TermsDetailFeature>

    public init(store: StoreOf<TermsDetailFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            // 1. 본문 (셀렉터 자리 만큼 하단 패딩 확보)
            mainContent
                .allowsHitTesting(!store.isVersionSelectorExpanded)

            // 2. expanded 시 화면 전체 dim — 탭하면 닫힘
            if store.isVersionSelectorExpanded {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.view(.versionSelectorExpandedChanged(false)))
                    }
                    .transition(.opacity)
                    .zIndex(1)
            }

            // 3. 셀렉터는 항상 하단 고정. expanded 되면 자기 위로 자라남(본문은 안 밀림)
            if store.showsVersionSelector {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    DSPolicyVersionSelector(
                        versions: store.versions.map {
                            .init(id: $0.id, label: $0.displayLabel)
                        },
                        selectedID: $store.selectedVersionID.sending(\.view.versionPicked),
                        isExpanded: $store.isVersionSelectorExpanded
                            .sending(\.view.versionSelectorExpandedChanged)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 33)
                }
                .zIndex(2)
            }
        }
        .background(Color.mainWhite)
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.25), value: store.isVersionSelectorExpanded)
    }

    // MARK: - 본문 (네비바 + 스크롤 + 셀렉터 자리 차지하는 spacer)

    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 0) {
            DSNavigationBar()
                .title(store.document.title)
                .leftItems([.pop])
                .onAction { action in
                    if case .popButtonTap = action {
                        store.send(.view(.backButtonTapped))
                    }
                }

            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(store.selectedVersion.segments.enumerated()), id: \.offset) { _, segment in
                        segmentView(segment)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.gray100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.stroke, lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)

            // 셀렉터 영역만큼 자리 비워두기 (셀렉터 높이 63 + bottom padding 33 + 윗 여백 16)
            if store.showsVersionSelector {
                Color.clear
                    .frame(height: 63 + 33)
            }
        }
    }

    @ViewBuilder
    private func segmentView(_ segment: TermsContentSegment) -> some View {
        switch segment {
        case let .text(markdown):
            Text(parsedMarkdown(markdown))
                .font(DSFontStyle.body2.font)
                .foregroundStyle(Color.gray500)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)

        case let .table(table):
            DSPolicyTable(
                headers: table.headers,
                rows: table.rows
            )
        }
    }

    private func parsedMarkdown(_ raw: String) -> AttributedString {
        (try? AttributedString(
            markdown: raw,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )) ?? AttributedString(raw)
    }
}

// MARK: - Previews

#Preview("개인정보 처리방침 (멀티 버전)") {
    NavigationStack {
        TermsDetailView(
            store: Store(initialState: TermsDetailFeature.State(document: .privacyPolicy)) {
                TermsDetailFeature()
            }
        )
    }
}

#Preview("이용약관 (단일 버전)") {
    NavigationStack {
        TermsDetailView(
            store: Store(initialState: TermsDetailFeature.State(document: .termsOfService)) {
                TermsDetailFeature()
            }
        )
    }
}

#Preview("마케팅 활용동의") {
    NavigationStack {
        TermsDetailView(
            store: Store(initialState: TermsDetailFeature.State(document: .marketingConsent)) {
                TermsDetailFeature()
            }
        )
    }
}
