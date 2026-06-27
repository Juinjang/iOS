import Foundation

public extension Result where Failure == Error {
    /// 임의의 `Error`를 앱 공통 `JuinjangError`로 매핑.
    /// 이미 `JuinjangError`면 그대로 두고, 아니면 `.clientError`로 감쌈.
    func mapToJuinjangError() -> Result<Success, JuinjangError> {
        mapError { ($0 as? JuinjangError) ?? .clientError($0.localizedDescription) }
    }
}
