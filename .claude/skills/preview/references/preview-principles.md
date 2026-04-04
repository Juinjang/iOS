# Preview Core Principles

## The Golden Rule
```
Preview = leaf view + fixed state + mock dependency + deterministic rendering
```

Every Preview must satisfy all four conditions. If any condition is missing,
the Preview will be slow, flaky, or crash.

## Absolute Rules (NEVER Break)

### 1. NEVER preview root or coordinator views
Root views like `AppView`, `TabRootView`, or any view that owns a
`NavigationStack` with multiple destinations are **off-limits** for Preview.
They pull in the entire dependency graph and are impossible to render deterministically.

```swift
// BAD - previewing root coordinator
#Preview {
    AppView(store: ...)  // pulls entire app dependency tree
}

// GOOD - preview individual leaf screens
#Preview {
    HomeView(store: ...)
}
```

### 2. NEVER let effects run in Preview
Network calls, disk I/O, analytics, logging -- none of these should execute
during Preview rendering. Effects cause non-determinism, delays, and crashes.

See: `preview-effect-guard.md` for the isPreview pattern.

### 3. NEVER initialize global state in Preview
Singletons, shared managers, UserDefaults writes, Keychain access -- these must
all be bypassed or mocked. Global state causes cross-Preview contamination and
unpredictable behavior.

### 4. Always use Example scheme for Preview in TMA
Feature modules are `staticFramework` in Tuist. Previews need a runnable target,
which is provided by the Example app scheme (e.g., `SplashExample`).

See: `preview-tma-structure.md` for details.

## View Body Optimization

### Split body into @ViewBuilder computed properties
Large SwiftUI `body` properties cause slow type inference in the compiler,
which directly impacts Preview load time.

```swift
struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        VStack {
            headerSection
            contentSection
            footerSection
        }
    }

    @ViewBuilder
    private var headerSection: some View {
        // header content
    }

    @ViewBuilder
    private var contentSection: some View {
        // main content
    }

    @ViewBuilder
    private var footerSection: some View {
        // footer content
    }
}
```

### Each state variant gets its own sub-view
When a view renders different layouts based on state (loaded, empty, loading, error),
extract each variant into a dedicated sub-view with its own Preview.

```swift
struct HomeContentView: View { ... }  // loaded state
struct HomeEmptyView: View { ... }    // empty state
struct HomeLoadingView: View { ... }  // loading skeleton
```

This reduces SwiftUI type inference complexity and enables faster, more focused Previews.

## Related
- `preview-state-patterns.md` - How to define fixed states
- `preview-dependency-mock.md` - How to mock dependencies
- `preview-effect-guard.md` - How to guard effects
- `preview-tma-structure.md` - Module-level Preview setup
