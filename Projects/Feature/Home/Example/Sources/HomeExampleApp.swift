import ComposableArchitecture
import DesignSystem
import Home
import SwiftUI

@main
struct HomeExampleApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                store: Store(initialState: HomeFeature.State()) {
                    HomeFeature()
                }
            )
        }
    }
}

// MARK: - Previews

#Preview("Home") {
    HomeView(
        store: Store(initialState: HomeFeature.State()) {
            HomeFeature()
        }
    )
}

// MARK: - DSNavigationBar Previews

#Preview("NavigationBar - Default") {
    VStack {
        DSNavigationBar()
            .title("홈")
            .leftItems([.pop])
            .rightItems([.search, .setting])
            .onAction { action in print("Action: \(action)") }

        Spacer()
    }
}

#Preview("NavigationBar - Search") {
    NavigationBarSearchPreview()
}

private struct NavigationBarSearchPreview: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            DSNavigationBar(style: .search, searchText: $searchText)
                .leftItems([.pop])
                .placeholder("검색어를 입력해주세요")
                .onAction { action in print("Action: \(action)") }

            Spacer()
        }
    }
}

#Preview("NavigationBar - Center (홈)") {
    VStack {
        DSNavigationBar(style: .center) {
            Image.logo
                .resizable()
                .scaledToFit()
                .frame(height: 24)
        }
        .leftItems([.setting])
        .rightItems([.record])
        .onAction { action in print("Action: \(action)") }

        Spacer()
    }
}

#Preview("NavigationBar - Center (탭)") {
    VStack {
        DSNavigationBar(style: .center) {
            HStack(spacing: 16) {
                DSText("전체").style(.title).textColor(.main)
                DSText("스크랩").style(.title).textColor(.gray400)
            }
        }
        .leftItems([.pop])
        .rightItems([.add])
        .onAction { action in print("Action: \(action)") }

        Spacer()
    }
}
