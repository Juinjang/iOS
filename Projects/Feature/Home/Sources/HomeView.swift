import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

// MARK: - Home View

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {

    @Bindable public var store: StoreOf<HomeFeature>

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("홈")
                .onAppear { send(.onAppear) }
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = store.errorMessage {
            errorView(message: errorMessage)
        } else {
            postListView
        }
    }

    private var postListView: some View {
        List(store.posts) { post in
            PostRow(post: post)
        }
        .refreshable { send(.refreshTapped) }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: DSSpacing.md) {
            Text("오류가 발생했습니다")
                .font(DSFont.title)
            Text(message)
                .font(DSFont.body)
            Button("다시 시도") {
                send(.refreshTapped)
            }
        }
    }
}

// MARK: - Post Row

private struct PostRow: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(post.title)
                .font(DSFont.body)
            Text(post.content)
                .font(DSFont.caption)
                .lineLimit(2)
        }
        .padding(.vertical, DSSpacing.xs)
    }
}

// MARK: - Preview

#Preview {
    HomeView(
        store: Store(initialState: HomeFeature.State()) {
            HomeFeature()
        }
    )
}
