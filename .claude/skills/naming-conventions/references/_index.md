# Naming Conventions Quick Reference

## API 네이밍

| HTTP Method | 접두사 | 예시 |
|-------------|--------|------|
| GET | `fetch` | `fetchUser`, `fetchFeed` |
| POST | `create` | `createPost`, `createRecord` |
| PATCH/PUT | `update` | `updateProfile`, `updateNote` |
| DELETE | `remove` | `removeItem`, `removeRecord` |

## Feature 파일 네이밍

| 종류 | 패턴 | 예시 |
|------|------|------|
| Reducer | `{Name}Feature.swift` | `MyNoteListFeature.swift` |
| View | `{Name}View.swift` | `MyNoteListView.swift` |
| ViewModel | `{Name}View+Model.swift` | `MyNoteListView+Model.swift` |
| 하위 View | `{Name}ItemView.swift` | `MyNoteListItemView.swift` |
| Example | `{Name}ExampleApp.swift` | `MyNoteListExampleApp.swift` |
| Tests | `{Name}FeatureTests.swift` | `MyNoteListFeatureTests.swift` |
