# API & Domain Naming Conventions

## HTTP Method → Domain Naming

| HTTP Method | 의미 | Domain 네이밍 | 뉘앙스 |
|-------------|------|--------------|--------|
| GET | 리소스 조회 | `fetch` / `get` / `load` | 원격에서 가져올 때 → `fetch`, 캐시/로컬 포함 → `get` / `load` |
| POST | 리소스 생성 | `create` / `register` / `add` | 일반 생성 → `create`, 회원가입 등 → `register` |
| PATCH / PUT | 리소스 수정 | `update` / `edit` / `modify` | 일부 변경 → `update`, 사용자가 직접 편집 → `edit` |
| DELETE | 리소스 삭제 | `delete` / `remove` / `cancel` | 영구 삭제 → `delete`, 목록에서 제거 → `remove`, 예약 취소 등 → `cancel` |

## 핵심 원칙
- HTTP 메서드 이름(`get`, `post`, `patch`, `delete`)을 **직접 사용하지 않는다**
- Domain 네이밍은 **어디서 데이터를 가져오는지 드러내지 않는다** (Remote/Local 중립)
- 같은 HTTP 메서드라도 **도메인 맥락에 맞는 단어**를 선택한다

## 예시

```swift
// ❌ HTTP 메서드 그대로
func getUser() async throws -> User
func postRecord() async throws -> Record
func deleteBookmark() async throws

// ✅ Domain 네이밍
func fetchUser() async throws -> User        // 원격 조회
func loadCachedFeed() -> [Post]              // 로컬/캐시 조회
func createRecord() async throws -> Record  // 생성
func registerUser() async throws -> User    // 회원가입
func updateProfile() async throws -> User   // 수정
func editNote() async throws -> Note        // 사용자 편집
func removeBookmark() async throws          // 목록에서 제거
func deleteAccount() async throws           // 영구 삭제
func cancelReservation() async throws       // 예약 취소
```

## @DependencyClient 적용 예시

```swift
@DependencyClient
public struct RecordClient {
    // GET → fetch (원격)
    public var fetchRecords: @Sendable () async throws -> [Record]
    // GET → load (로컬/캐시)
    public var loadDraft: @Sendable () -> Record?
    // POST → create
    public var createRecord: @Sendable (_ record: Record) async throws -> Record
    // POST → register
    public var registerPush: @Sendable (_ token: String) async throws -> Void
    // PATCH → update
    public var updateRecord: @Sendable (_ id: String, _ record: Record) async throws -> Record
    // DELETE → remove (목록 제거)
    public var removeRecord: @Sendable (_ id: String) async throws -> Void
    // DELETE → delete (영구 삭제)
    public var deleteAccount: @Sendable () async throws -> Void
    // DELETE → cancel (취소 맥락)
    public var cancelBooking: @Sendable (_ id: String) async throws -> Void
}
```
