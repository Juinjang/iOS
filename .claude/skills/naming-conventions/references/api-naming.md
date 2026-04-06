# API Endpoint 네이밍 규칙

## HTTP Method별 네이밍

| HTTP Method | Network 의미 | Domain 네이밍 | 뉘앙스 |
|-------------|-------------|--------------|--------|
| GET | 리소스 조회 | `fetch` / `get` / `load` | 원격에서 가져올 때 → `fetch`, 캐시/로컬 포함 → `get`/`load` |
| POST | 리소스 생성 | `create` / `register` / `add` | 생성 → `create`, 회원가입 등 → `register` |
| PATCH/PUT | 리소스 수정 | `update` / `edit` / `modify` | 일부 변경 → `update`, 사용자가 직접 편집 → `edit` |
| DELETE | 리소스 삭제 | `delete` / `remove` / `cancel` | 영구 삭제 → `delete`, 목록에서 제거 → `remove`, 예약 취소 → `cancel` |

## 중립 접미사 (기본 사용)

| HTTP | 접두사 | 예시 |
|------|--------|------|
| GET | `fetch` | `fetchUser`, `fetchFeed` |
| POST | `create` | `createPost`, `createRecord` |
| PATCH/PUT | `update` | `updateProfile`, `updateNote` |
| DELETE | `remove` | `removeItem`, `removeRecord` |

## DependencyClient 적용 예시

```swift
@DependencyClient
public struct APIClient: Sendable {
    // GET
    public var fetchHomeFeed: @Sendable () async throws -> [Post]
    public var fetchUserProfile: @Sendable (_ userId: String) async throws -> User
    public var fetchNoteDetail: @Sendable (_ noteId: Int) async throws -> NoteDetail

    // POST
    public var createNote: @Sendable (_ request: CreateNoteRequest) async throws -> Note
    public var registerUser: @Sendable (_ request: RegisterRequest) async throws -> User

    // PATCH/PUT
    public var updateNote: @Sendable (_ noteId: Int, _ request: UpdateNoteRequest) async throws -> Note
    public var updateProfile: @Sendable (_ request: UpdateProfileRequest) async throws -> User

    // DELETE
    public var removeNote: @Sendable (_ noteId: Int) async throws -> Void
    public var removeScrap: @Sendable (_ scrapId: Int) async throws -> Void
}
```

## Reducer Action에서의 네이밍

```swift
public enum Action {
    case view(View)
    case delegate(Delegate)

    // API 응답 Action — Response 접미사
    case homeFeedResponse(Result<[Post], Error>)
    case noteDetailResponse(Result<NoteDetail, Error>)

    // 또는 loaded/failed 패턴
    case feedLoaded([Post])
    case feedFailed(Error)
}
```

## 네이밍 선택 기준

- **원격 API 호출** → `fetch` (가장 일반적)
- **로컬 DB/캐시 조회** → `get` 또는 `load`
- **회원가입/초대** → `register` / `invite`
- **좋아요/스크랩 토글** → `toggleLike` / `toggleScrap`
- **목록에서 제거 (soft delete)** → `remove`
- **영구 삭제 (hard delete)** → `delete`
- **예약/구독 취소** → `cancel`
