# Feature 파일/폴더 네이밍 규칙

## Feature 폴더 구조

```
Features/{Name}/
├── Sources/
│   ├── {Name}Feature.swift              # Reducer
│   ├── {Name}View.swift                 # 메인 View
│   ├── ViewModels/                      # ViewModel (View+Model 분리)
│   │   ├── {Name}View+Model.swift
│   │   └── {Name}ItemView+Model.swift
│   └── Views/                           # 하위 View 컴포넌트
│       ├── {Name}ItemView.swift
│       └── {Name}ScrapItemView.swift
├── Example/Sources/
│   └── {Name}ExampleApp.swift
├── Testing/Mock/
│   └── Mock{Name}Data.swift
└── Tests/
    └── {Name}FeatureTests.swift
```

## 파일 네이밍 규칙

### Reducer
- `{Name}Feature.swift`
- 예: `MyNoteListFeature.swift`, `LoginFeature.swift`, `SplashFeature.swift`

### View
- 메인 View: `{Name}View.swift`
- 하위 View: `{Name}ItemView.swift` (리스트 셀 등)
- 예: `MyNoteListView.swift`, `MyNoteListItemView.swift`, `MyScrapItemView.swift`

### ViewModel (View+Model 패턴)
- `{Name}View+Model.swift`
- View에서 사용할 데이터 모델을 extension으로 분리
- 예: `MyNoteListView+Model.swift`, `MyNoteListItemView+Model.swift`

```swift
// MyNoteListView+Model.swift
extension MyNoteListView {
    struct Model: Equatable, Identifiable {
        let id: Int
        let title: String
        let thumbnailURL: URL?
        let createdAt: Date
    }
}
```

### Example
- `{Name}ExampleApp.swift`
- Preview는 이 파일에서만 작성
- 예: `MyNoteListExampleApp.swift`

### Tests
- `{Name}FeatureTests.swift`
- 예: `MyNoteListFeatureTests.swift`

### Mock
- `Mock{Name}Data.swift` 또는 `Mock{Name}Client.swift`
- 예: `MockMyNoteListData.swift`

## 실제 예시 — MyNoteList

```
Features/MyNoteList/
├── Sources/
│   ├── MyNoteListFeature.swift
│   ├── MyNoteListView.swift
│   ├── ViewModels/
│   │   ├── MyNoteListView+Model.swift
│   │   └── MyNoteListItemView+Model.swift
│   └── Views/
│       ├── MyNoteListItemView.swift
│       └── MyScrapItemView.swift
├── Example/Sources/
│   └── MyNoteListExampleApp.swift
├── Testing/Mock/
│   └── MockMyNoteListData.swift
└── Tests/
    └── MyNoteListFeatureTests.swift
```

## 네이밍 규칙 요약

| 종류 | 패턴 | 위치 |
|------|------|------|
| Reducer | `{Name}Feature` | Sources/ |
| 메인 View | `{Name}View` | Sources/ |
| 하위 View | `{Name}ItemView` | Sources/Views/ |
| ViewModel | `{Name}View+Model` | Sources/ViewModels/ |
| Example | `{Name}ExampleApp` | Example/Sources/ |
| Tests | `{Name}FeatureTests` | Tests/ |
| Mock | `Mock{Name}Data` | Testing/Mock/ |
